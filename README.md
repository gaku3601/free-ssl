# free-ssl
This Dockerfile provide free ssl environment by Let's encrypt + nginx + docker.  
This support automatic renewal.(Automatic renewal run every Monday AM4:00 JST.)  
  
# usage
This use as follows.
```
version: '3'

services:
    nginx:
        image: gaku3601/free-ssl:latest
        ports:
            - 80:80
            - 443:443
        links:
            - nginx2
        environment:
            MAIL: 'pro.gaku@gmail.com' # your mail address
            DOMAIN: 'takuto.gakusmemo.com' # site domain
            STAGE: 'staging' # staging or production
            REVERSE_PROXY: 'http://nginx2'
    nginx2:
        image: nginx:1.13.8
```
  
This docker-compose example apply ssl environment to nginx2 component.  
Please always set up four environment variable.  
MAIL: Set your mail address.  
DOMAIN: Set your side domain name.  
STAGE: Set staging or production.  

    staging: Issue a certificate for Test.
    production: Issue a certificate for Production.(There is a limit on the number of ssl certificate issuance per day.)
 
REVERSE_PROXY: Set component name url to apply ssl environment.  
You can get a secure environment at setting avobe.  
