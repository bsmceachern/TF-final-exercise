# TF-final-exercise

Our decision making process
1. we decided to go with the MERN stack deploy because based on the progress of our group. we had made it farther through the MERN exercise compared to the DynamoDB section, so we felt more comfortable doing the MERN option.
2. Steps we took for our TF file - high level
    we decided to take the following workflow so we could easily establish what went wrong before doing multiple things at the same time, reducing number of errors in our implementation  
   a. edit main .tf   
   b. terraform apply  
   c. verify in amazon management console that it worked  
   d. git add/commit  
   e. move onto next resource   
   
   
3. main.tf steps - order of resources  
    a. architecture  
         1. tried to follow a similar setup as the first image that was shown in the checkpoint page in Learn, so we could have a visual aide to help our work  
       <h2>Front end</h2>  
         1. VPC  
         2. public subnet  
         3. public subnet security group  
         4. route table  
         5. route table > public subnet association  
         6. EC2 instance for front end app  
         7. bash script to install/update/clone front end project - the execution of this script is commented out while we worked on backend/db because it implies the connection               can be made from front end to backend, which we did 2nd  
       
     <h2>Back end</h2> 
         1. private subnet<br />
         2. private subnet security group
         3. route table - we decided to use default main route table for this since the configuration for it fit our needs for the private subnet without needing it in our main.tf<br />
         4. EC2 instance - database<br />
         5. EC2 instance - backend service - we decided to make the database first, service second to make configuring the backend easier (needs db connection)<br />
         6. bash script to install necessary software/git clone for backend service<br />


Randall  

Kayla  
1. things learned - importance and difference of ingress/egress for route tables
2. what to do if we had more time - 


Branden  
1. things learned - being able to ssh into a private subnet by being in the public subnet, as long as they're in the same VPC, importance and difference of ingress/egress for route tables  
2. what to do if we had more time - figure out more about shell scripting, change approach to introducing shell scripts. would have been beneficial to install every thing manually first, then go through and create the bash scripts more methodically instead of all at once, right off the bat. 
         
     
