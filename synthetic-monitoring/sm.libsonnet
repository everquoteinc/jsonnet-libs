local sm = import 'sm.libsonnet';
{
  syntheticMonitoring+:: {
    grafanaCheck: sm.new('grafana-com', 'https://grafana.com/')
                  + sm.withHttp()
                  + sm.withProbes('all'),
  },
}
{
  new(name, target):: {
    frequency: 60000,
    offset: 0,
    timeout: 2500,
    enabled: true,
    labels: [],
    target: target,
    job: name,
  },

  withHttp():: {
    settings: {
      http: {
        ipVersion: 'V4',
        method: 'GET',
        noFollowRedirects: false,
        failIfSSL: false,
        failIfNotSSL: false,
      },
    },
  },
  withTcp():: {
    settings: {
      tcp: {
        ipVersion: 'V4',
        tlsConfig: {},
      },
    },
  },
  withDns():: {
    settings: {
      dns: {
        ipVersion: 'V4',
        port: 53,
        protocol: 'UDP',
        recordType: 'A',
        server: '8.8.8.8',
        validRCodes: [
          'NOERROR',
        ],
        validateAnswerRRS: {},
        validateAuthorityRRS: {},
      },
    },
  },
  withPing():: {
    settings: {
      ping: {
        dontFragment: false,
        ipVersion: 'V4',
      },
    },
  },

  _probeList:: {
    americas: [
      'Atlanta',
      'Chicago',
      'Dallas',
      'LosAngeles',
      'Miami',
      'Newark',
      'NewYork',
      'SanJose',
      'SanFrancisco',
      'Seattle',
      'Toronto',
    ],
    asia: [
      'Bangalore',
      'Tokyo',
      'Mumbai',
      'Seol',
      'Singapore',
    ],
    europe: [
      'Amsterdam',
      'Frankfurt',
      'London',
      'Paris',
    ],
    australasia: [
      'Sydney',
    ],
    continents: ['NewYork', 'Paris', 'Singapore', 'Sydney'],
    all: self.americas + self.asia + self.europe + self.australasia,
    small: ['SanFrancisco', 'NewYork', 'Singapore', 'London', 'Sydney'],
  },

  withProbes(set):: {
    probes+: $._probeList[set],
  },
}
