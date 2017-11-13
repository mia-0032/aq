# aq (Athena Query CLI)

Command Line Tool for AWS Athena (bq command like)

## Installation

Install by gem:

```bash
$ gem install aq
```

## Usage

All commands need `--bucket` option because Athena stores query result into S3.
You can specify it by `AQ_DEFAULT_BUCKET` environment variable.

### ls

Show databases or tables in specified database

```bash
$ aq ls
$ aq ls my_database_name
```

### mk

Create database

```bash
$ aq mk my_database_name
```

### load

Create table and load data

```bash
$ aq load my_db.my_table s3://my_bucket/my_object_key/ test/resource/schema.json --partitioning dt:string
```

### query

Run query

```bash
$ aq query 'SELECT * FROM "test"."test_logs" limit 10;'
```

## Development

todo: write

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mia-0032/aq
