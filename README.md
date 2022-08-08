## Docker

> -   윈도우에서 리눅스를 사용할 수 있는 wsl을 실행하는것과 같은 Virtual Machine처럼 운영체제를 설치하는 것과 유사한 효과를 낼 수 있는 독립된 실행 환경을 만들어주지만 실제 운영체제를 설치하는 것이 아니기 때문에 설치 용량은 적고 실행속도 또한 빠르다.

## Docker 설치

https://happylie.tistory.com/78 < 참고 >

## Docker 파일 만들기

```javascript
FROM node:16-alpine
```

> -   기본적으로 Docker 파일을 만들때 항상 FROM으로 base Img를 설정해주어야 합니다. node같은 경우에는 이미 만들어둔 이미지가 있습니다.
> -   16은 node의 버전을 의미하고 alpine은 가장 최소단위의 리눅스 버전을 의미합니다.
> -   Command를 누르고 node를 클릭해보면 노드js에서 사용가능한 모든 baseImg를 확인할 수 있습니다.

```javascript
WORKDIR / app;
```

> -   이미지 파일안에서 어떤 디렉토리의 어플리케이션을 복사해 올 것인지 명시합니다.

```javascript
COPY package.json package-lock.json ./
```

> -   도커 파일에서는 Layer 시스템으로 구성이 되어있기 때문에 자주 변경되는 파일일수록 가장 마지막에 적어주어야 합니다.
> -   따라서 현재 프로젝트에서 가장 변경되지 않는 package.json 파일과 package-lock.json 파일을 COPY합니다.

```javascript
RUN npm ci
```

> -   Package-lock.json 파일에 명시되어 있는 version으로 설치하기 때문에 version 이 조금 달라지는것을 방지할 수 있습니다.

```javascript
COPY server.js ./
```

> -   마지막으로 server.js 파일을 COPY합니다.

```javascript
ENTRYPOINT[('node', 'server.js')];
```

> -   node를 실행할 것인데 server.js 파일을 실행해라는 명령어입니다.

### 전체 Dockfile 코드

```javascript
// layer1
FROM node:16-alpine

// layer2
WORKDIR /

// layer3
COPY package.json package-lock.json ./

// layer4
RUN npm ci

// layer5
COPY server.js ./

// layer6
ENTRYPOINT [ "node" , "server.js" ]
```

> -   위와 같이 layer 방식으로 처리되기 때문에 server.js 파일을 수정할 경우 변경된 layer 5 위로만 업데이트 하고 나머지 layer는 다시 만들지 않아도 되기 때문에 가장 변경될 파일을 끝쪽 layer에 추가합니다.

## DockerFile로 Image 만들기

```javascript
docker build -f Dockerfile -t fun-docker .
```

> -   . = build context를 의미하며 docker에게 너가 필요한 docker file의 위치를 지정해줍니다.
> -   -f = 어떤 Dockerfile을 사용할 것인지 명시해줍니다. Default = Dockerfile
> -   -t = docker image에 이름을 부여할 수 있습니다

```javascript
docker images
```

> -   해당 명령어를 사용하면 local Machine에 만든 image를 확인할 수 있습니다.

## Docker Image 실행

```javascript
docker run -d -p 8080:8080 fun-docker
```

> -   -d = 명령어를 실행하고 터미널은 할일 하라는 명령어
> -   -p 8080:8080 = server.js의 8080포트와 container를 8080 포트로 연결합니다. ( server port : container port )

```javascript
docker ps
```

> -   현재 실행중인 container를 확인할 수 있습니다.

## Docker Hub

> -   회원가입 후 Create Repository 합니다.
> -   우측에 `docker push ansuhwan/docker-test:tagname` 이런식으로 Image push 하라고 하니 파일명을 바꿔줍니다.
> -   `docker tag fun-docker:latest ansuhwan/docker-test:latest`
> -   docker tag 명령어로 fun-docker Image의 파일명 바꿔줍시다.
> -   docker images를 실행하면 변경한 파일명을 가진 Image 파일이 추가된것을 확인할 수 있습니다.
> -   `docker login` 명령어로 docker 로그인 합니다.
> -   `docker push ansuhwan/docker-test:latest`로 Docker Hub에 Push 합니다.
