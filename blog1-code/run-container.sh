
docker build -t jenkins:jcasc-blog-1 .
docker run --name jenkins --rm -p 8080:8080 --env JENKINS_ADMIN_PASSWORD=password jenkins:jcasc-blog-1