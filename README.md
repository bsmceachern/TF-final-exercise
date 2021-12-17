# TF-final-exercise

Our decision making process
1. we decided to go with the MERN stack deploy because based on the progress of our group. we had made it farther through the MERN exercise compared to the DynamoDB section, so we felt more comfortable doing the MERN option.
2. Steps we took for our TF file - high level
    we decided to take the following workflow so we could easily establish what went wrong before doing multiple things at the same time, reducing number of errors in our             implementation
   a. edit main .tf 
   b. terraform apply
   c. verify in amazon management console that it worked
   d. git add/commit
   e. move onto next resource 
   
   
3. main.tf steps - order of resources
    a. architecture
         1. tried to follow a similar setup as the first image that was shown in the checkpoint page in Learn, so we could have a visual aide to help our work
    b. steps
       Front end
         1. VPC
         2. public subnet
         3. public subnet security group
         4. route table
         5. route table > public subnet association
         6. EC2 instance for front end app
         7. bash script to install/update/clone front end project - the execution of this script is commented out while we worked on backend/db because it implies the connection               can be made from front end to backend, which we did 2nd
       
       Back end
         i. private subnet
     
