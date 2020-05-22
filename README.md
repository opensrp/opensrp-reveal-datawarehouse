# Reveal Data Warehouse Migrations

This document describes the database system for Reveal.

## Dependencies

- This database system uses [sqitch](https://sqitch.org/) to manage migrations.
- The Reveal data warehouse depends on these [database utilities](1-utils/README.md).

## Naming Conventions

You will notice that all the directories are named with a number as a prefix.  This is only necessary to ensure that tests run in the desired order.

## Database Setup

Setting up entails:

1. Creating a Postgres Database and Database user.
2. Running the queries in the [database setup](3-reveal/setup/README.md) section.
3. Running the queries in the [performance tweaks](3-reveal/performance-tweaks/README.md) section, if desired.
4. Running the [utility database migrations](1-utils/README.md) using sqitch.

## Ingestion

The Reveal data comes from an [OpenSRP server](https://github.com/OpenSRP/opensrp-server-web), and is fed into this database system by a Reveal-flavoured [OpenSRP Connector](https://github.com/onaio/canopy/blob/master/docs/connectors/opensrp-connector.md).  On ingestion, this data is stored in [raw data tables](https://github.com/onaio/canopy/tree/master/docs/connectors#raw-data-strategy), as follows:

OpenSRP Entity|Raw Data Table
---|---
Events| raw_events
Structures|raw_structures
Jurisdictions|raw_jurisdictions
Tasks|raw_tasks
Plans|raw_plans

\* "Structures" as used in this document can be defined as OpenSRP locations that are not jurisdictions, i.e. which have `is_jurisdiction=False`.

More information on the raw tables is [here](2-common-migrations/README.md) (for raw_events) and [here](3-reveal/migrations/1-raw_tables/README.md) (for the rest).

## Transform & Load

The Reveal connector then transforms the raw data and stores them into ["transaction" tables](3-reveal/migrations/2-transaction_tables/README.md).  Note that this transformation happens in the Reveal connector, and not in the database.  The end result is a number of database tables on which further operations can be performed.

These are the resulting "transaction" tables:

- actions
- clients
- events
- goals
- goal_target
- jurisdictions
- plan_jurisdiction
- plans
- structures
- tasks

More information [here](3-reveal/migrations/2-transaction_tables/README.md).

One of these operations is the setting up of [basic general purpose materialized views](3-reveal/migrations/3-views/README.md) from the transaction tables.  These views are used and re-used many times in other parts of the system.

To support specific use-cases, the Reveal database next does some implementation-specific things.  Each of this is only necessary if needed.  These are:

### Focus Investigation (FI)

The end result here is that some materialized views are set up to be consumed by the Reveal web application for FI reports.

1. [Thailand 2019](3-reveal/migrations/4-FI/1-Thailand-2019/README.md)

### Indoor Residual Spraying (IRS)

The end result here is that some materialized views are set up to be consumed by the Reveal web application for IRS reports.

1. [Generic stuff](3-reveal/migrations/5-IRS/1-generic/README.md)
2. [Zambia 2019](3-reveal/migrations/5-IRS/2-Zambia-2019/README.md)
3. [Namibia 2019](3-reveal/migrations/5-IRS/3-Namibia-2019/README.md)

## Jobs

To keep the database fresh, the system includes [some queries](3-reveal/jobs/README.md) which are meant to be run periodically.

## Superset

[This section](3-reveal/superset/README.md) contains queries that are meant to be used to build Superset slices.

## NiFi

[These queries](3-reveal/nifi/README.md) are used to in NiFi flows.

## Monitoring

Finally, there are some [utilities to help in monitoring](3-reveal/migrations/99-monitoring/README.md) so that the database can be more observable and errors easier to find.

This directory is meant to hold all Reveal data warehouse migrations.

## Other Included migrations

1. [Utilities](1-utils/README.md)
2. [Common OpenSRP Migrations](2-common-migrations/README.md)

## Contribution

1. Clone this repo
2. Install dependencies

   ```sh
   apt install sqitch libdbd-pg-perl postgresql-client libdbd-sqlite3-perl sqlite3
   ```

3. Submit code for review

## Testing

This repo has been set up to automatically run database migration tests using sqitch on CircleCI.  This is to ensure that no PR with failing migrations is overlooked.

### Testing Database migrations locally

To test locally, you need the following:

1. Install sqitch locally
2. Install your database management system of choice and set up a test database like so:

    - Database name: `sqitch_test`
    - Database user name: `sqitch`
    - Database user password: `secret`

    One easy way to do this is to use the docker-compose.yml file (if Docker Compose is installed):

    ```sh
    docker-compose up -d
    ```

    > Note that the docker-compose.yml file assumes there isn't an existing Postgres database on the :5432 port.

Once you are done with the above, you can run sqitch tests using this command:

```sh
# run tests
find . -iname sqitch.conf -print0 | sort -zn | xargs -I {} -0 bash -c 'cd `dirname {}` && pwd && sqitch deploy sqitch_test && sqitch verify sqitch_test'
# revert them
find . -iname sqitch.conf -print0 | sort -znr | xargs -I {} -0 bash -c 'cd `dirname {}` && pwd && sqitch revert -y sqitch_test'
```

Note that the above command runs sqitch tests for all projects.

To run tests for one project, do the following:

```sh
cd <into directory that contains sqitch.plan and sqitch.conf>
sqitch deploy sqitch_test && sqitch verify sqitch_test && sqitch revert -y sqitch_test
```

You can also alternatively use the [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/) to run tests.
