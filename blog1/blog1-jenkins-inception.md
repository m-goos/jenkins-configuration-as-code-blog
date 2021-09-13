# Jenkins inception: configuring Jenkins to configure Jenkins
Jenkins is an open source automation server that development teams use to build, test and deploy their applications. If you have worked in an environment with CI/CD pipelines, chances are that you have used Jenkins. And because Jenkins has so many configuration options and plugins available, it can be quite an effort to set up.

Now imagine configuring all of your infrastructure *as code*, but configuring the tool that builds, tests and deploys your infrastructure and applications *through a web UI*. Sounds counterintuitive, right? In this blog, I’ll show you how to configure Jenkins as code. The next blog in this series, I’ll talk about even setting up your pipeline configuration in a fully automated, version controlled way. If you already know why you use Jenkins, you can skip the first paragraph:
1. (Blog 1) Why a build server, and why Jenkins?
1. (Blog 1) Jenkins: Configuration as Code (JCasC) plugin
1. (Blog 1) Automating Jenkins configuration with Docker and JCasC
1. (Blog 2) Automating pipeline setup: Jenkins Job DSL plugin
1. (Blog 2) Why I did not get the ‘perfect’ setup running yet..
1. (Blog 3) Passing secrets to your Jenkins container from AWS ECS

While I went through this setup for a Jenkins controller, I did not find everything to be as clear or well-documented as I would have wished. Hopefully this article will clear some things up! *[Find the repository here]()*

![Stairs](images/stairs.jpg)

*How deep do you want to go down the Configuration as Code rabbit hole? [Maxime Lebrun](https://unsplash.com/photos/1o2071GOVp0) on Unsplash*

*Prerequisites: some basic experience with Docker and Jenkins, see [Jenkins Tutorials](https://www.jenkins.io/doc/tutorials/) and [Docker getting started](https://docs.docker.com/get-started/).*

# Why a build server, and why Jenkins?
The reason to set up a CI/CD pipeline is simple: to automate deployment of your projects, and to standardize your process of deploying to production, configured to your needs. Here’s a little example I drew in *excalidraw*:

![jenkins-usecase](images/jenkins-usecase.png)

Using a build server just makes your life easier - once your CI/CD process is set up that is. Once your automatic builds start coming through whenever you push code changes, you’ll find out how rewarding it is to see your code *live* just minutes after.

Now why Jenkins? There are many ways to set up a CI/CD pipeline, to name a few from major cloud and software providers:
- Github Actions
- Gitlab CI/CD pipelines
- Bitbucket Runners / Pipelines or Atlassian Bamboo
- AWS Codepipeline
- Spinnaker (Netflix)
- And the list goes on..

The reason I am choosing Jenkins here is because it is widely supported, considered to be an industry standard, open source and highly configurable. This blog is not a comparison of CI/CD tools however, so I won’t go into details. If you have a small project, it doesn’t pay off to set up Jenkins - you will not need the configurability for Continuous Integration. In that case I’d recommend quickly setting up your pipeline through Github, Gitlab or AWS. I’m not saying those aren’t highly configurable, but they are just simpler to set up for small projects.

With the right configuration scripts, it becomes really quick to set up Jenkins. Let’s move on to that setup!

# Jenkins Configuration as Code (JCasC)
Configuring a Jenkins controller or agent can be a hassle, as there are many different plugins and many steps to configure before a Jenkins pipeline runs, things like:
- installing plugins,
- checking out your code repositories,
- configuring users and various credentials,
- deploying the build.

Now you could write Groovy scripts to directly invoke the Jenkins API for the desired configuration, but that requires advanced knowledge of the Jenkins API. For my case, investing in this kind of knowledge was simply not worth it. 

A good alternative is the Jenkins Configuration as Code [plugin](https://github.com/jenkinsci/configuration-as-code-plugin), JCasC for short. The JCasC plugin allows the user to define all the configuration options for the Jenkins instance as code, in a `yaml` file. That configuration file would then look something like this:

`jenkins-configuration.yaml`:

```​​
jenkins:
  systemMessage: "All configuration for this controller is done as code (JCasC)"
  securityRealm:
    local:
      allowsSignup: false
      users:
      - id: "admin"
        password: "${JENKINS_ADMIN_PASSWORD}" # passing ENV variable from Docker here
        properties:
        - timezone:
            timeZoneName: "Europe/Amsterdam"
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
  remotingSecurity:
    enabled: true
security:
  queueItemAuthenticator:
    authenticators:
    - global:
        strategy: triggeringUsersAuthorizationStrategy
unclassified:
  location:
    url: http://localhost:8080
```

This configuration file can then be checked into git, giving you an editing history of your configuration. Defining your configuration as code provides the same advantages Infrastructure as Code does. One aspect is auditability, because all configuration is explicit and can thus be checked for e.g. security concerns. Another aspects is repeatability, because the instance can be easily redeployed, duplicated and version controlled. [The list goes on](https://techspire.nl/why-infrastructure-as-code/)...

With a first configuration file ready, it is time to prepare a Docker container with a customized Jenkins instance.

## Automating Jenkins configuration with Docker and JCasC
For this step you’ll need to have Docker installed and tested. If you are new to Docker, your could start with the examples from the Docker tutorials. To run a customized Jenkins container with Docker, with the Configuration as Code plugin:

1. Create a Dockerfile to define the configuration of the Jenkins container
2. List the necessary plugins for Jenkins
3. Pull & Build the latest Jenkins image with Docker
4. Run the Jenkins container locally, passing the right parameters

Once the Jenkins instance is running successfully locally, you might want to run the Jenkins container on e.g. Azure, AWS or GCP - but that's another story.

### Step 1: Create a Dockerfile 
For creation of the container, there are a couple steps. 
```zsh
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY controller-configuration.yaml /var/jenkins.yaml
```

```zsh
docker pull jenkins/jenkins:latest
```
Alternatively, choose to download a Jenkins LTS release. https://www.jenkins.io/download/lts/

2:


Below are all the commands outlined

We’ll take the following steps:
Download the latest official Jenkins Docker image
Set some environment variables for the configuration of Jenkins
Copy a list of plugins to install into the Jenkins container
Run the built-in script that install the plugins from our list

Make sure to start Docker’s UI, or the docker-daemon from your command line. 

Now 
Explain:
Get the latest Jenkins image,
Set ENV variables for Jenkins to find the its way
Copy in a plugins file
Install the plugins
Now the configuration as code plugin is ready, so: copy in the configuration and apply it

Dockerfile: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
 
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY controller-configuration.yaml /var/casc.yaml

The order here is crucial 

The `copy` step with the plugins.txt, make sure to include the configuration as code plugin. The following list is sourced and adapted to my needs from the [Jenkins Github repository](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/jenkins/install/platform-plugins.json). 

https://github.com/jenkinsci/docker#preinstalling-plugins

Also include the `job-dsl` plugin, as we will need it in the next step of this blog:

```
ant:latest
antisamy-markup-formatter:latest
authorize-project:latest
build-timeout:latest
cloudbees-folder:latest
configuration-as-code:latest
credentials:latest
email-ext:latest
git:latest
gradle:latest
job-dsl:latest
ldap:latest
mailer:latest
matrix-auth:latest
nodejs:latest
pam-auth:latest
pipeline-stage-view:latest
ssh-slaves:latest
timestamper:latest
workflow-aggregator:latest
ws-cleanup:latest
```
For production, you might want to add a specific version, not ‘latest’, to ensure stability when rebuilding your Jenkins image.
