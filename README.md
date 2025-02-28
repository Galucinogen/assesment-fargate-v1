# symmetrical-spork

Deploy service with AWS Fargate using terraform

## Directory layout

    .
    ├── scripts                            # scripts to run terraform & tests
    ├── terraform
      - aws                                # Terraform AWS infrastructure
    ├── tests                              # Infrastructure tests
    ├── Makefile                           # Set of tasks to execute
    └── README.md                          # Documentation

## Proposed Infrastructure Architecture

![design](design.jpg "Architecture")

* AWS Fargate
* AWS Application Load Balancer

The application load balancer should have an `/service` endpoint and `/__healthcheck__` health check endpoint.

If something is missing, feel free adding it to a solution.

## Objectives

The task objectives were as follows:

* Create infrastructure-as-code as per proposed Architecture
* `Makefile` has all the commands requred to run/test
* Explain how to run in `README.md`

Optional

* Test Infrastructure (you can choose one or more test frameworks)
	* [Terraform BDD Testing](https://github.com/eerkunt/terraform-compliance)
	* [Terraform Unit Testing](https://github.com/bsnape/rspec-terraform)
	* [Terraform Ultimate Testing](https://github.com/bsnape/rspec-terraform)

## Deploy

TODO: Document how to run

## Test the whole setup

terraform-compliance is available as as pip package in PyPi.

It requires Python 3.x to run properly. Installation is pretty standard like any Python package.

[~] $ pip install terraform-compliance

Run:

[~] $ make tests

## Note

Not make pull requests. Fork/Clone the repo instead and work on it. Master branches only.

There is no need to deploy infrastructure to AWS. Just make sure it fully valid terraform infrastructure-as-code setup.