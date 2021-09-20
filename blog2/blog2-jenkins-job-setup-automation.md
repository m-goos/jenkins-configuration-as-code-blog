# Automatically set up Jenkins jobs from a git repository (JCasC & JobDSL plugin)
Jenkins is an automation server used by development teams for CI/CD processes. It takes quite some work to properly configure Jenkins and the pipelines for automating software deployment. This blog details how to both automate and version control the setup of Jenkins Pipelines and is aimed at slightly advanced Jenkins users. 

## Goal of this blog
The goal of this blog is that, once you start your Jenkins container, you can just press play to let Jenkins set up the necessary jobs. These jobs are checked into a code repository and their configuration can thus be audited and easily replicated if the Jenkins server goes down or has to be migrated for some reason. Another benefit of this setup is that changes in job configuration can be deployed through a pipeline. A high-level overview of the setup looks like this:

![jenkins](images/flow-2.png)

## Contents
1. Getting started: test your setup (Docker)
2. Add seed job to Configuration as Code setup (JCasC/JobDSL)
3. Create seed job repository (Jenkinsfile/JobDSL)
4. Results: 

## 1. Getting started: test your setup (Docker)
This blog builds on the concept of the `Jenkins Configuration as Code` plugin. It requires some basic proficiency with Docker. Although this blog can be read independent from my previous Jenkins blog, you might want to have a look there if this concept new for you. Read it [here](https://techspire.nl/jenkins-inception-configuring-jenkins-to-configure-jenkins/). I use `zsh` on a mac, so you might have to adjust some of the terminal code snippets if you're on a different platform.

To get started, clone the following [repository](https://github.com/m-goos/jenkins-configuration-as-code-blog) and go to the `blog2-code` directory to follow along:
```zsh
$ git clone https://github.com/m-goos/jenkins-configuration-as-code-blog

$ cd blog2-code
$ ls
Dockerfile
controller-configuration-jobDSL.yaml
plugins.txt
```

Now let's do a quick check of your environment and setup. You should be able to run the following container that can be built from the `Blog2-code` directory:
```sh
# start Docker or the docker-daemon
$ pwd
/Users/marc/projects/blog-jenkins-configuration-as-code/blog2-code

$ 

```

## 2. Add seed job to Configuration as Code setup (JCasC/JobDSL)

## 
## Terminology
Seed Job:
JobDSL plugin: 
Jenkins Configuration as Code plugin: 

This blog relies on two Jenkins plugins:
1. Jenkins Configuration as Code plugin
1. Job DSL plugin

And many more, but I won't be naming plugins like git and the pipelines plugin.

*Prerequisistes*
I will build on blog 1
- If you are experienced with Jenkins, to kickstart clone this repo and `cd` into blog1-code: 
- 

## Goal: set up Jenkins jobs automatically
Goal of the blog is to set up Jenkins in a way that it gets the configuration 
- JCasC/JobDSL to seed the controller with a 'seed job'
- get Jenkins to check out a local git repository
    - create a local git repository



## Why I haven't realized a 'fully' automated setup
Ideally, the seed job would be run 

jobDsl queue is a bit flaky and runs into a chicken-egg problem with Jenkins startup and queueing.
see https://github.com/jenkinsci/configuration-as-code-plugin/issues/280
see also https://github.com/jenkinsci/configuration-as-code-plugin/issues/619
- script: queue("initialize-pipelines")

## Next steps
- create credentials for external git repository
- check out external git repository
