# devops-exercise
An exercise in devops. A simple webpage built using Python's Flask as well as configuration 
files for managing an automated infrastructure.

## Web Page
 - **main.py**: Flask App that collects metrics and passes them into variables to be created 
   via render_template module. This file is used to start the application.

 - **templates**: Folder containing templated HTML file that will use values from main.py

 - **static**: Folder containing static CSS file used for styling the webpage.

## Infrastructure
 - **Dockerfile**: Used for creating the image
 - **main.tf**: Used for terraform, contains all Infra as Code for automated adds/modifies/deletes.
### Container Build & Deployment
uwsgi-nginx-flask python image was used as the base for the webapp as flask by itself is not intended for use in production. It must be used in conjunction with uwsgi and a web server like nginx. This image seemed like the best choice for the job.

Once the docker image was built, I pushed the image to the AWS ECR in order to store the repository. This way if a code change is needed, I can push the new image to the repository easily.

I decided to use Fargate to host the container as it's intended use case is best for small workloads such as this. Also eliminates the burden of maintaining a linux EC2 host.


If more containers are needed, a task can simply be created in the AWS Console or main.tf can be modified to create more infrastructure if needed.
