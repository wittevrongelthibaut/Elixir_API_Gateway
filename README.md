# ApiGateway

## Description

This is an API Gateway for the Homars platform. This gateway is responsible for the communication between the Homars platform and the external world.

### Technology stack

- This microservice is written in **Elixir** and uses the **Phoenix framework**.
- This service communicates with the **Homars services** through a message broker (**RabbitMQ**) using **Remote Procedure Calls (RPC)**.
- To use the **RabbitMQ** message broker, this service uses the **AMQP** package.

### Deployment

This service is deployed and the API is accessible on following url: https://gateway.djelalfida.com/api.<br>
We use **Coolify** to automatically deploy the microservice inside a **Docker container**.

## Installation

Here is an installation guide on how to run this microservice locally.

### Requirements

- **Elixir** version 1.12 or later
- **Erlang** version 22 or later
- Acces to a **RabbitMQ message bus**

### Installation

1. Clone the repository to your local machine. This can be done through the following command:

```bash

git clone git@git.ti.howest.be:TI/2022-2023/s5/trending-topics-sd/students/mars05/api-gateway.git

```

2. Navigate to the root of the project and open a command line prompt.

3. install the dependencies by running the following command:

```bash

mix deps.get

```

4. Create a **env.secret.exs** file in the config directory of the project. This file should contain the variables that are used in the **.env.example.exs** file.


5. Run the following command to start the microservice:

```bash

mix phx.server

```

## Usage

Now you will see that the microservice is running on 127.0.0.1:4000. You can now use the API to communicate with the microservice. The endpoints are listed in the [API spec](https://git.ti.howest.be/TI/2022-2023/s5/trending-topics-sd/students/mars05/documentation/-/blob/main/api-spec/openapi-homars.yaml)
