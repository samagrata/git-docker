# git-docker

Contains Dockerfile to run git commands and connect with SSH key

Specify an email when building the image:

```bash
docker build --build-arg SSH_EMAIL="your_actual_email@example.com" -t git-ssh-image .
```

Add the printed SSH key to your account and start using the container to run git commands from your project directory:

```bash
docker run -it -v "$(pwd):/project" -w /project git-ssh-image <your command>
```

You should configure a local email and name for this git image.