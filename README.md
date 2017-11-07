# aq (Athena Query CLI)

Command Line Tool for AWS Athena (bq command like)

## Installation

Install by gem:

```bash
$ gem install aq
```

## Usage

All commands need `--bucket` option because Athena stores query result into S3.

### ls

Show databases or tables in specified database

```bash
$ aq ls --bucket=aws-athena-query-results-xxxx-region
$ aq ls my_database_name --bucket=aws-athena-query-results-xxxx-region
```

### mk

Create database

```bash
$ aq mk my_database_name --bucket=aws-athena-query-results-xxxx-region
```

### load

Create table and load data

```bash
$ aq load my_db.my_table s3://my_bucket/my_object_key/ test/resource/schema.json --partitioning dt:string --bucket=aws-athena-query-results-xxxx-region
```

### query

Run query

```bash
$ aq query 'SELECT * FROM "test"."test_logs" limit 10;' --bucket=aws-athena-query-results-xxxx-region
```

## Development

todo: write

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mia-0032/aq
