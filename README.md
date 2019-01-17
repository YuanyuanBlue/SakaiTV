To use our project, please use terminal to change directory to the project and
type "pod init" to init the fod file. If you didn't install pod before, please 
type "sudo gem install cocoapods" in your terminal to download pod.

This is our SakaiTV, which enables users access sakai on TV without their Mac. 
We have several sakai entries including resources, assignment, class, grade,
profile, announcement, membership, syllabus and lessons. We use master-detail 
viewcontroller to display these entries. When click each entry's title tab in
the left side, the content of that entry would display in the right panel.

membership: this is our first main view to display all the courses that user 
enrolled. After the user clicks one of the course, all other entries' would
automatically change to according content. 

announcement: use a tableview controller to show all the annoucnement. When a
cell is clicked, a uiview would display to show the body of that annoucement.
We copied several announcement from 564 and add them into test sakai site, 
download the json, and extract the their title and body. We faked the author 
and modified date to make it looks more real.

syllabus: the cell in tableview controller can expand or collapse. when user 
click a syllabu, the cell would expand to display another cell that contains 
the syllabu's content. When user click again, the content cell would collapse. 
It's worth mentioning that the content cell can autosizing based on the text 
length. We get the syllabus data from the api call.

lessons: it is designed based on the lessons entry in ECE564 sakai page.
Because webview call is disabled in tvos, We stored several lessons from 564 in 
PDF format and add them in the repo. When user clicks a lessons cell, according
pdf would opend in a uiviewcontroller. PS: if you test our project on simulator,
please press OPTION button and scroll on remote's pad. You can exit pdf displaying 
by clicking the MENU button on remote. Same as the pdf in class's entry. 

resources: users can oepn pdf file, jpeg files as well as png files. Resource 
entries are displayed using collection view. 

assignments: we use collectionview to display all the assignments. On the top,
we have two buttons, which enable user to sort assignments by newest released 
order or due most soon order.

gradebook: users can see their grades on this page. We used tableView to display
the grades.

youtube: it is a highlight of our project. Users can display specific youtube 
videos through this app.

class: This is for display all the instructors, TAs and classmates in this course.
Initially it only show the instructor, TA and our three team members, after we 
click the get button, all classmates enrolled in this course would show up. To use
GET function, ECE564 server needs to run.

profile:

calendar:

In this project we only show the data of ece564 course, course 650 is empty and 
course 551 just displays some data in its gradebook.
