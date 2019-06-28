# vim: syntax=python tabstop=4 expandtab

__author__ = "Joel Ås"
__email__ = "joel.as@medsci.uu.se"

from itertools import product


def get_expected_output(rules_obj, target_rules, wc_outside_rules):
    """
    Get expected inputs for aggregation rule form chosen down-stream rules. See /rules/multiqc/test/ for example.
    Observe that all rules called from this rule needs to be defined before this function is called.
    :param rules_obj: Rules() object produced by snakemake, use 'rules' in target rules input
    :param target_rules: dict on format {"rule_name": {"output": "output_variable", **additional_affixes}.
                        Additional suffixes are expected wildcards in output of rules to aggregate.
                        Ex: /{sample}_{read_number}.fastq, where 're_number' should be additional_affixes
    :param wc_outside_rules: dict specifying all values of wildcards given outside and is common to all rules, such as sample id.
    :return: List of all expected input given wildcards and output from target rules.
    """
    def _check_parameters(rule_name, rule_dict, rules):
        if not hasattr(rules, rule_name):
            raise AttributeError("No rule {} in workflow".format(rule_name))

        if not "output"in rule_dict or rule_dict["output"] is None:
            raise KeyError("No output variable defined for rule {}".format(rule_name))

        for param, value in rule_dict.items():
            if value is None:
                raise AttributeError("No values defined for parameter {} in rule {}".format(param, rule_name))

    expected_input = []
    for target_rule in target_rules:
        params_of_rule = target_rules[target_rule]
        _check_parameters(target_rule, params_of_rule, rules_obj)

        output_variable = params_of_rule.pop("output")
        expr_wildcards = wc_outside_rules
        expr_wildcards.update(params_of_rule)
        output_expression = getattr(getattr(rules_obj, target_rule).output, output_variable)

        all_combinations = product(*(expr_wildcards[param] for param in expr_wildcards))
        all_named_combinations = [dict(zip(expr_wildcards, combination)) for combination in all_combinations]
        expected_input += [
            output_expression.format(**named_combination) for named_combination in all_named_combinations
        ]

    return expected_input
