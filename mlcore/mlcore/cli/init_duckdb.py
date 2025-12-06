import yaml

def main():
    with open('env.yml', 'r') as f:
        config = yaml.safe_load(f)

    access_key = config.get('aws_access_key_id')
    secret_key = config.get('aws_secret_access_key')
    region = config.get('region', 'eu-central-1')


    print("INSTALL httpfs;")
    print("LOAD httpfs;")
    print("INSTALL parquet;")
    print("LOAD parquet;")
    print(
        f"""
        CREATE SECRET (
            TYPE S3,
            KEY_ID '{access_key}',
            SECRET '{secret_key}',
            REGION '{region}'
        );
        """
    )

    # print("SET s3_use_object_cache = true;")
    # print("SET enable_progress_bar = true;")
    print("SET memory_limit = '4GB';")
    print("SET threads = 4;")


if __name__ == "__main__":
    main()
