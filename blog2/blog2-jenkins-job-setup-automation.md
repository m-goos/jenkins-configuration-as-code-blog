# Automatically set up Jenkins jobs from a git repository (JCasC & JobDSL plugin)
Jenkins is an automation server used by development teams for CI/CD processes. It takes quite some work to properly configure Jenkins and the pipelines for automating software deployment. This blog details how to both automate and version control the setup of Jenkins Pipelines and is aimed at slightly advanced Jenkins users. 

Although this blog can be read independent from my previous Jenkins blog, you might want to have a look there if the use of the `Configuration as Code` plugin isn't a given. Otherwise, clone the following repository and go to the `blog2-code` directory to follow along:
```
$ git clone @@@

$ cd blog2-code
$ ls -la

```



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
    - 


Extra steps:
- create credentials for external git repository
- check out external git repository


## Why I haven't realized a 'fully' automated setup
Ideally, the seed job would be run 

jobDsl queue is a bit flaky and runs into a chicken-egg problem with Jenkins startup and queueing.
see https://github.com/jenkinsci/configuration-as-code-plugin/issues/280
see also https://github.com/jenkinsci/configuration-as-code-plugin/issues/619
- script: queue("initialize-pipelines")