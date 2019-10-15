# Augmentedbackend
The "Augmented htwSaar" Backend Service.


### Requirements
AugmentedBackend requires:
* [Apache Maven](https://maven.apache.org/) 
* JDK/OpenJDK 10+ 
* docker (optional)
* docker-compose (optional)

to run.

### Installation

Install the maven and execute the following commands:

```sh
$ git clone <project url> augmentedbackend
$ cd augmentedbackend
$ mvn compile
$ mvn package
$ mvn exec:java
```

### Documentation
The api-documentation can be found at http://localhost:8080/swagger-ui.html

### Docker
Run via `docker-compose up`

docker-compose will automatically trigger a build if no image exists.

Rebuild the image via `docker-compose build`.