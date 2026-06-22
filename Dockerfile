FROM ubuntu
RUN apt-get update && apt-get install -y nginx
RUN rm -rf /var/www/html/*
#COPY index.html /var/www/html/index.html
#COPY self_pic.jpeg /var/www/html/self_pic.jpeg
COPY student_survey.html /var/www/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]