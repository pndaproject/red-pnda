{
    "FsRepository": {
        "location": {
            "path": "{{ FS_LOCATION_PATH |default('/mnt/packages') }}"
        }
    },
    "config": {
        "log_level":"INFO",
        "package_callback": "{{ DATA_LOGGER_URL |default('console_backend_data_logger:3001')}}/packages"
    }

}

