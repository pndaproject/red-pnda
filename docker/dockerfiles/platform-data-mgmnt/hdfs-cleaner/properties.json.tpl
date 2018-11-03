{
    "hadoop_distro":"{{ HADOOP_DISTRO | default('env') }}",
    "cm_host":"{{ CM_HOST | default('cm') }}",
    "cm_user":"{{ CM_USER | default('scm') }}",
    "cm_pass":"{{ CM_PASSWORD | default('scm') }}",
    "datasets_table":"platform_datasets",
    "spark_streaming_dirs_to_clean": [],
    "general_dirs_to_clean": [ "/user/history/done/" ],
    "old_dirs_to_clean": [],
    "swift_repo": "swift://{{ ARCHIVE_CONTAINER | default('archive') }}.pnda/{{ CLUSTER_NAME | default('pnda')}}",
    "container_name": "{{ ARCHIVE_CONTAINER | default('archive') }}",
    "s3_archive_region": "{{ AWS_ARCHIVE_REGION | default('') }}",
    "s3_archive_access_key": "{{ AWS_ARCHIVE_KEY | default('') }}",
    "s3_archive_secret_access_key": "{{ AWS_ARCHIVE_SECRET | default('') }}",
    "swift_account":"{{ KEYSTONE_TENTANT | default('') }}",
    "swift_user": "{{ KEYSTONE_USER | default('') }}",
    "swift_key": "{{ KEYSYONE_PASSWORD | default('') }}",
    "swift_auth_url": "{{ KEYSTONE_AUTH_URL | default('') }}"
}
