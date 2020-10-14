#PromSonnet

`PromSonnet` is intended as a very simple library for creating Prometheus
alerts and rules. It is 'patching friendly', as in, it maintains the
rules internally as a map, which allows users to easily patch alerts and
recording rules after the fact. (With lists, this requires iteration, and
is complex.

Take this example:

```
local prom = import 'prom.libsonnet';
local promRuleGroupSet = prom.v1.ruleGroupSet;
local promRuleGroup = prom.v1.ruleGroup;
{
  prometheus_up::
    promRuleGroup.new('prometheus_up')
    + promRuleGroup.rule.new(
      'PrometheusUp', {
        alert: 'PrometheusUp',
        expr: 'up',
        'for': '5m',
        labels: {
          namespace: 'prometheus',
          severity: 'critical',
        },
        annotations: {
        },
      }
    ),

  prometheusAlerts+:
    promRuleGroupSet.new()
    + promRuleGroupSet.addGroup($.prometheus_up),
}
```

If we wanted to change the `for` from `5m` to `10m`, we could do this
simply with code such as:

```
{
  prometheusAlerts+: {
    groups_map+:: {
      prometheus_up+:: {
        rules+:: {
          PrometheusUp+:: {
            for: '10m',
          },
        },
      },
    },
  },
}
```

We no longer need to iterate over all alerts to do so.

You can execute either of these examples in the `promsonnet` directory
via:
```
$ jsonnet example.jsonnet
$ # or:
$ jsonnet patch.jsonnet
```