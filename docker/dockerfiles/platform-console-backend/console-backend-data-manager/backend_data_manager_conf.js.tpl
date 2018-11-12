/* This file was generated from a template */

var hosts = '{{ CONSOLE_FRONTEND_HOSTS_CSV |default('127.0.0.1') }}';
var port = '{{ CONSOLE_FRONTEND_PORT|default('None') }}';
var whitelist = hosts.split(',');
whitelist.forEach(function(p, i, a) {
  a[i] = "http://"+a[i]+ ((port=='None')?'':':'+port);
});
module.exports = {
  whitelist: whitelist,
  deployment_manager: {
    host: "{{DEPLOYMENT_MANAGER_URL|default('http://127.0.0.1:5000')}}",
    API: {
      endpoints: "/environment/endpoints",
      packages_available: "/repository/packages?recency=999",
      packages: "/packages",
      applications: "/applications"
    }
  },
  dataset_manager: {
    host: "{{DATASET_MANAGER_URL|default('http://127.0.0.1:7000')}}",
    API: {
     datasets: "/api/v1/datasets"
    }
  },
  session: {
    secret: "data-manager-secret",
    max_age: 86400000
  }
};
