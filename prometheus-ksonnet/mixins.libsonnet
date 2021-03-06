{
  // Add you mixins here.
  mixins+:: {
    kubernetes:
      (import 'kubernetes-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Kubernetes',
        grafanaDashboardShards: 8,

        _config+:: {
          cadvisorSelector: 'job="kube-system/cadvisor"',
          kubeletSelector: 'job="kube-system/kubelet"',
          kubeStateMetricsSelector: 'job="%s/kube-state-metrics"' % $._config.namespace,
          nodeExporterSelector: 'job="%s/node-exporter"' % $._config.namespace,  // Also used by node-mixin.
          notKubeDnsSelector: 'job!="kube-system/kube-dns"',
          kubeSchedulerSelector: 'job="kube-system/kube-scheduler"',
          kubeControllerManagerSelector: 'job="kube-system/kube-controller-manager"',
          kubeApiserverSelector: 'job="kube-system/kube-apiserver"',
          podLabel: 'instance',
          notKubeDnsCoreDnsSelector: 'job!~"kube-system/kube-dns|coredns"',
        },
      },

    prometheus:
      (import 'prometheus-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Prometheus',

        _config+:: {
          prometheusSelector: 'job="default/prometheus"',
          prometheusHAGroupLabels: 'job,cluster,namespace',
          prometheusHAGroupName: '{{$labels.job}} in {{$labels.cluster}}',
        },
      },

    alertmanager:
      (import 'alertmanager-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'Alertmanager',

        _config+:: {
          alertmanagerSelector: 'job="default/alertmanager"',
          alertmanagerClusterLabels: 'job, namespace',
          alertmanagerName: '{{$labels.instance}} in {{$labels.cluster}}',
        },
      },

    node_exporter:
      (import 'node-mixin/mixin.libsonnet') {
        grafanaDashboardFolder: 'node_exporter',

        _config+:: {
          nodeExporterSelector: 'job="%s/node-exporter"' % $._config.namespace,  // Also used by node-mixin.

          // Do not page if nodes run out of disk space.
          nodeCriticalSeverity: 'warning',
          grafanaPrefix: '/grafana',
        },
      },

    grafana:
      (import 'grafana-mixin/mixin.libsonnet'),
  },
}
