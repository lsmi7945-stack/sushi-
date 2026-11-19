# SDG 9 Database Project: Technology Challenges in Underfunded Schools

## Project Overview 
Our project focuses on Sustainable Development Goal 9 (SDG 9): Industry, Innovation, and Infrastructure, specifically addressing technology challenges faced by underfunded schools. Many schools struggle with limited access to technology, outdated devices, unreliable internet connections, and insufficient funding to improve their resources. These challenges can affect students' learning experiences and teachers' ability to effectively use technology in the classroom. The purpose of our project is to design a relational database that collects, organizes, and analyzes information about schools' technology resources and challenges. By examining this information, we hope to identify common technology-related problems, compare the resources available at different schools, and determine which schools may need additional support.

To collect this information, our project will use three main data sources: school information forms, staff surveys, and school technology needs-ranking forms. School information forms will provide general information about each school, including student enrollment, the number of available devices, internet speeds, and technology budgets. Staff surveys will allow teachers, administrators, and other school employees to report technology-related issues they experience, such as poor Wi-Fi connections, outdated computers, or insufficient devices. The needs-ranking forms will allow schools to identify and prioritize the technology improvements they consider most important. For this project, we will use mock data to represent the information that could realistically be collected from these sources.

We will organize this information into related tables using MySQL. The Schools table will store general information about each school, while the Surveys table will contain responses collected from school staff. The Issues table will identify specific technology problems, and the Needs table will identify possible improvements that could address those problems. The SchoolNeeds table will connect schools to their identified technology needs and priority rankings collected through the needs-ranking forms. These tables will be connected using primary and foreign keys, allowing us to analyze information across multiple schools while reducing unnecessary data duplication. This structure will help us identify patterns, compare technology resources, and better understand which improvements may be needed.

Our database will be designed to answer three main questions:

1. Which technology needs are most commonly reported by schools? We will analyze survey responses and identified needs to determine which technology problems and improvements are most frequently reported.
2. Which schools have the greatest need for additional technology resources? We will compare student enrollment, the number of available devices, internet speeds, and technology budgets to identify schools experiencing the greatest technology shortages.
3. What technology issues should be prioritized for improvement? We will examine reported issues and school needs rankings to determine which improvements are considered most important.
   
Overall, our database will demonstrate how organizing and analyzing technology-related information can help schools make more informed decisions about allocating resources. By identifying common problems and areas of greatest need, our project supports SDG 9 by focusing on improving technological infrastructure and access to technology in schools.

Sources
United Nations, Goal 9
UNICEF and ITU, Two thirds of the world's school-age children have no internet access at home, 2020
SWI swissinfo.ch, How the UN plans to connect every school to the internet by 2030, 2024
GovTech, Report: 3 in 4 school districts meet FCC internet speed standards, 2023
Gemini, used to make the mock data spreadsheet
Our project proposal

