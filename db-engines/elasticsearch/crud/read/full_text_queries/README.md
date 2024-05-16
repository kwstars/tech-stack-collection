## 0. prepare

```json
POST _bulk
{"index":{"_index":"books","_id":"1"}}
{"title": "Core Java Volume I â€“ Fundamentals","author": "Cay S. Horstmann","edition": 11, "synopsis": "Java reference book that offers a detailed explanation of various features of Core Java, including exception handling, interfaces, and lambda expressions. Significant highlights of the book include simple language, conciseness, and detailed examples.","amazon_rating": 4.6,"release_date": "2018-08-27","tags": ["Programming Languages, Java Programming"]}
{"index":{"_index":"books","_id":"2"}}
{"title": "Effective Java","author": "Joshua Bloch", "edition": 3,"synopsis": "A must-have book for every Java programmer and Java aspirant, Effective Java makes up for an excellent complementary read with other Java books or learning material. The book offers 78 best practices to follow for making the code better.", "amazon_rating": 4.7, "release_date": "2017-12-27", "tags": ["Object Oriented Software Design"]}
{"index":{"_index":"books","_id":"3"}}
{"title": "Java: A Beginnerâ€™s Guide", "author": "Herbert Schildt","edition": 8,"synopsis": "One of the most comprehensive books for learning Java. The book offers several hands-on exercises as well as a quiz section at the end of every chapter to let the readers self-evaluate their learning.","amazon_rating": 4.2,"release_date": "2018-11-20","tags": ["Software Design & Engineering", "Internet & Web"]}
{"index":{"_index":"books","_id":"4"}}
{"title": "Java - The Complete Reference","author": "Herbert Schildt","edition": 11,"synopsis": "Convenient Java reference book examining essential portions of the Java API library, Java. The book is full of discussions and apt examples to better Java learning.","amazon_rating": 4.4,"release_date": "2019-03-19","tags": ["Software Design & Engineering", "Internet & Web", "Computer Programming Language & Tool"]}
{"index":{"_index":"books","_id":"5"}}
{"title": "Head First Java","author": "Kathy Sierra and Bert Bates","edition":2, "synopsis": "The most important selling points of Head First Java is its simplicity and super-effective real-life analogies that pertain to the Java programming concepts.","amazon_rating": 4.3,"release_date": "2005-02-18","tags": ["IT Certification Exams", "Object-Oriented Software Design","Design Pattern Programming"]}
{"index":{"_index":"books","_id":"6"}}
{"title": "Java Concurrency in Practice","author": "Brian Goetz with Tim Peierls, Joshua Bloch, Joseph Bowbeer, David Holmes, and Doug Lea","edition": 1,"synopsis": "Java Concurrency in Practice is one of the best Java programming books to develop a rich understanding of concurrency and multithreading.","amazon_rating": 4.3,"release_date": "2006-05-09","tags": ["Computer Science Books", "Programming Languages", "Java Programming"]}
{"index":{"_index":"books","_id":"7"}}
{"title": "Test-Driven: TDD and Acceptance TDD for Java Developers","author": "Lasse Koskela","edition": 1,"synopsis": "Test-Driven is an excellent book for learning how to write unique automation testing programs. It is a must-have book for those Java developers that prioritize code quality as well as have a knack for writing unit, integration, and automation tests.","amazon_rating": 4.1,"release_date": "2007-10-22","tags": ["Software Architecture", "Software Design & Engineering", "Java Programming"]}
 {"index":{"_index":"books","_id":"8"}}
 {"title": "Head First Object-Oriented Analysis Design","author": "Brett D. McLaughlin, Gary Pollice & David West","edition": 1,"synopsis": "Head First is one of the most beautiful finest book series ever written on Java programming language. Another gem in the series is the Head First Object-Oriented Analysis Design.","amazon_rating": 3.9,"release_date": "2014-04-29","tags": ["Introductory & Beginning Programming", "Object-Oriented Software Design", "Java Programming"]}
 {"index":{"_index":"books","_id":"9"}}
 {"title": "Java Performance: The Definite Guide","author": "Scott Oaks","edition": 1,"synopsis": "Garbage collection, JVM, and performance tuning are some of the most favorable aspects of the Java programming language. It educates readers about maximizing Java threading and synchronization performance features, improve Java-driven database application performance, tackle performance issues","amazon_rating": 4.1,"release_date": "2014-03-04","tags": ["Design Pattern Programming", "Object-Oriented Software Design", "Computer Programming Language & Tool"]}
 {"index":{"_index":"books","_id":"10"}}
 {"title": "Head First Design Patterns", "author": "Eric Freeman & Elisabeth Robson with Kathy Sierra & Bert Bates","edition": 10,"synopsis": "Head First Design Patterns is one of the leading books to build that particular understanding of the Java programming language." ,"amazon_rating": 4.5,"release_date": "2014-03-04","tags": ["Design Pattern Programming", "Object-Oriented Software Design eTextbooks", "Web Development & Design eTextbooks"]}
 {"index":{"_index":"books","_id":"11"}}
 {"title": "JavaScript - The Definitive Guide", "author": "David Flanagan","edition": 1,"synopsis": "JavaScript is the programming language of the web and is used by more software developers today than any other programming language. For nearly 25 years this best seller has been the go-to guide for JavaScript programmers." ,"amazon_rating": 4.7,"release_date": "2020-05-29","tags": ["Design Pattern Programming", "Object-Oriented Software Design eTextbooks", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"12"}}
 {"title": "Eloquent Javascript", "author": "Marijn Haverbeke","edition": 3,"synopsis": "JavaScript lies at the heart of almost every modern web application, from social apps like Twitter to browser-based game frameworks like Phaser and Babylon. Though simple for beginners to pick up and play with, JavaScript is a flexible, complex language that you can use to build full-scale applications." ,"amazon_rating": 4.6,"release_date": "2018-12-14","tags": ["DOM", "Node.js","object-oriented and functional programming techniques", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"13"}}
 {"title": "JavaScript and JQuery: Interactive Front–End Web", "author": "Jon Duckett","edition": 1,"synopsis": "This full-color book adopts a visual approach to teaching JavaScript & jQuery, showing you how to make web pages more interactive and interfaces more intuitive through the use of inspiring code examples, infographics, and photography." ,"amazon_rating": 4.7,"release_date": "2014-07-18","tags": ["DJavaScript and jQuery", "JavaScript APIs, and jQuery plugins", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"14"}}
 {"title": "A Smarter Way to Learn JavaScript", "author": "Mark Myers","edition": 1,"synopsis": "JThe first problem is retention. You remember only ten or twenty percent of what you read. That spells failure. To become fluent in a computer language, you have to retain pretty much everything." ,"amazon_rating": 4.6,"release_date": "2014-03-20","tags": ["Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"15"}}
 {"title": "Head First JavaScript Programming", "author": "Eric T. Freeman and Elisabeth Robson","edition": 1,"synopsis": "This brain-friendly guide teaches you everything from JavaScript language fundamentals to advanced topics, including objects, functions, and the browser’s document object model." ,"amazon_rating": 4.5,"release_date": "2014-04-10","tags": ["The secrets of JavaScript types", "The inner details of JavaScript", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"16"}}
 {"title": "Modern JavaScript for the Impatient", "author": "Cay Horstmann","edition": 1,"synopsis": "Modern JavaScript for the Impatient is a complete yet concise guide to JavaScript E6 and beyond. Rather than first requiring you to learn and transition from older versions, it helps you quickly get productive with today’s far more powerful versions and rapidly move from languages such as Java, C#, C, or C++." ,"amazon_rating": 4.9,"release_date": "2020-08-18","tags": ["modern JavaScript", "Object-Oriented Programming", "JavaScript libraries, frameworks, and platforms"]}
 {"index":{"_index":"books","_id":"17"}}
 {"title": "JavaScript in easy steps", "author": "Mike McGrath","edition": 6,"synopsis": "JavaScript in easy steps, 6th edition instructs the user how to create exciting web pages that employ the power of JavaScript to provide functionality. You need have no previous knowledge of any scripting language so it's ideal for the newcomer to JavaScript. By the end of this book you will have gained a sound understanding of JavaScript and be able to add exciting dynamic scripts to your own web pages." ,"amazon_rating": 4.4,"release_date": "2020-02-28","tags": ["Get Started in JavaScript", "Interact with the Document", "Create Web Applications"]}
 {"index":{"_index":"books","_id":"18"}}
 {"title": "JavaScript: The Good Parts", "author": "Douglas Crockford","edition": 1,"synopsis": "Most programming languages contain good and bad parts, but JavaScript has more than its share of the bad, having been developed and released in a hurry before it could be refined. This authoritative book scrapes away these bad features to reveal a subset of JavaScript that's more reliable, readable, and maintainable than the language as a whole—a subset you can use to create truly extensible and efficient code." ,"amazon_rating": 4.5,"release_date": "2008-05-18","tags": ["Design Pattern Programming", "Object-Oriented Programming", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"19"}}
 {"title": "JavaScript Everywhere", "author": "Adam Scott","edition": 1,"synopsis": "JavaScript is the little scripting language that could. Once used chiefly to add interactivity to web browser windows, JavaScript is now a primary building block of powerful and robust applications. In this practical book, new and experienced JavaScript developers will learn how to use this language to create APIs as well as web, mobile, and desktop applications." ,"amazon_rating": 4.5,"release_date": "2020-02-21","tags": ["Building Cross-platform Applications with GraphQL, React, React Native, and Electron", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"20"}}
 {"title": "JavaScript The Complete Reference", "author": "Thomas A. Powell and Fritz Schneider","edition": 3,"synopsis": "Design, debug, and publish high-performance web pages and applications using tested techniques and best practices from expert developers. The all-new edition of this comprehensive guide has been thoroughly revised and expanded to cover the latest JavaScript features, tools, and programming methods." ,"amazon_rating": 4.3,"release_date": "2012-09-16","tags": ["XMLHttpRequest object to create Ajax applications", "DOM", "Programming Languages, Javascript Programming"]}
 {"index":{"_index":"books","_id":"21"}}
 {"title": "The C# Player's Guide", "author": "RB Whitaker","edition": 5,"synopsis": "The book in your hands is a different kind of programming book. Like an entertaining video game, programming is an often challenging but always rewarding experience. This book shakes off the dusty, dull, dryness of the typical programming book, replacing it with something more exciting and flavorful: a bit of humor, a casual tone, and examples involving dragons and asteroids instead of bank accounts and employees." ,"amazon_rating": 5.0,"release_date": "2022-01-14","tags": ["basic mechanics of C#", "object-oriented programming", "advanced C# features"]}
 {"index":{"_index":"books","_id":"22"}}
 {"title": "C# 10 and .NET 6", "author": "Mark J. Price","edition": 1,"synopsis": "You will learn object-oriented programming, writing, testing, and debugging functions, implementing interfaces, and inheriting classes. The book covers the .NET APIs for performing tasks like managing and querying data, monitoring and improving performance, and working with the filesystem, async streams, serialization, and encryption. It provides examples of cross-platform apps you can build and deploy, such as websites and services using ASP.NET Core." ,"amazon_rating": 4.6,"release_date": "2021-11-09","tags": ["real-world applications", "latest features of C# 10 and .NET 6", "Visual Studio 2022 and Visual Studio Code"]}
 {"index":{"_index":"books","_id":"23"}}
 {"title": "C# Programming in easy steps", "author": "Mike McGrath","edition": 2,"synopsis": "C# Programming in easy steps, 2nd edition will teach you to code applications, and demonstrates every aspect of the C# language you will need to produce professional programming results. Its examples provide clear syntax-highlighted code showing C# language basics including variables, arrays, logic, looping, methods, and classes." ,"amazon_rating": 4.6,"release_date": "2020-05-29","tags": ["programming in C#", "creating apps", "fundamental understanding of C#"]}
 {"index":{"_index":"books","_id":"24"}}
 {"title": "Professional C# and .NET", "author": "Christian Nagel","edition": 1,"synopsis": "Experienced programmers making the transition to C# will benefit from the author’s in-depth explorations to create Web- and Windows applications using ASP.NET Core, Blazor, and WinUI using modern application patterns and new features offered by .NET including Microservices deployed to Docker images, GRPC, localization, asynchronous streaming, and much more." ,"amazon_rating": 4.5,"release_date": "2022-03-04","tags": ["extension of .NET to non-Microsoft platforms like OSX and Linux", "Microsoft Azure services such as Azure App", "C# 10 and .NET 6"]}
 {"index":{"_index":"books","_id":"25"}}
 {"title": "Head First C#", "author": "Stellman, Andrew, Greene and Jennifer","edition": 4,"synopsis": "What will you learn from this book? For beginning programmers looking to learn C#, this practical guide provides a bright alternative to the legions of dull tutorials on this popular object-oriented language." ,"amazon_rating": 4.6,"release_date": "2021-01-29","tags": ["Real-World Programming with C# and .Net Core", "Object-oriented language", "multi-sensory learning"]}
 {"index":{"_index":"books","_id":"26"}}
 {"title": "C# 9.0 in a Nutshell", "author": "Albahari and Joseph","edition": 1,"synopsis": "When you have questions about C# 9.0 or .NET 5, this bestselling guide has the answers. C# is a language of unusual flexibility and breadth, but with its continual growth, there's so much more to learn. In the tradition of O'Reilly's Nutshell guides, this thoroughly updated edition is simply the best one-volume reference to the C# language available today." ,"amazon_rating": 4.5,"release_date": "2021-03-31","tags": ["C# and .NET", "pointers, closures, and patterns Dig deep into LINQ", "Programming Languages"]}
 {"index":{"_index":"books","_id":"27"}}
 {"title": "C# in Depth", "author": "Jon Skeet","edition": 4,"synopsis": "C# is an amazing language that's up to any challenge you can throw at it. As a C# developer, you also need to be up to the task." ,"amazon_rating": 4.6,"release_date": "2019-05-20","tags": ["C# 5, 6, and 7", "better code with tuples, string interpolation, pattern matching"]}
 {"index":{"_index":"books","_id":"28"}}
 {"title": "C# Data Structures and Algorithms", "author": "Marcin Jamro","edition": 1,"synopsis": "Data structures allow organizing data efficiently. They are critical to various problems and their suitable implementation can provide a complete solution that acts like reusable code. In this book, you will learn how to use various data structures while developing in the C# language as well as how to implement some of the most common algorithms used with such data structures." ,"amazon_rating": 4.6,"release_date": "2018-04-19","tags": ["Implement algorithms", "Build enhanced applications by using hashtables, dictionaries and sets", "Programming Languages, C#"]}
 {"index":{"_index":"books","_id":"29"}}
 {"title": "Learning C# by Developing Games with Unity 3D", "author": "Terry Norton","edition": 1,"synopsis": "For the absolute beginner to any concept of programming, writing a script can appear to be an impossible hurdle to overcome. The truth is, there are only three simple concepts to understand: 1) having some type of information; 2) using the information; and 3) communicating the information. Each of these concepts is very simple and extremely important. These three concepts are combined to access the feature set provided by Unity." ,"amazon_rating": 3.9,"release_date": "2013-09-25","tags": ["Unity C# scripts", "GameObjects and Component objects", "Unity's Scripting"]}
 {"index":{"_index":"books","_id":"30"}}
 {"title": "Pro C# 9 with .NET 5", "author": "Andrew Troelsen and Phillip Japikse","edition": 1,"synopsis": "This essential classic provides a comprehensive foundation in the C# programming language and the framework it lives in. Now in its 10th edition, you will find the latest C# 9 and .NET 5 features served up with plenty of "behind the curtain" discussion designed to expand developers’ critical thinking skills when it comes to their craft. Coverage of ASP.NET Core, Entity Framework Core, and more, sits alongside the latest updates to the new unified .NET platform, from performance improvements to Windows Desktop apps on .NET 5, updates in XAML tooling, and expanded coverage of data files and data handling. Going beyond the latest features in C# 9, all code samples are rewritten for this latest release." ,"amazon_rating": 4.7,"release_date": "2021-06-08","tags": ["C# 9 features", "ASP.NET Core web applications and web services", "C# and modern frameworks for services"]}
 {"index":{"_index":"books","_id":"31"}}
 {"title": "Python Crash Course", "author": "Eric Matthes","edition": 2,"synopsis": "Reading books is a kind of enjoyment. Reading books is a good habit. We bring you a different kinds of books. You can carry this book where ever you want. It is easy to carry. It can be an ideal gift to yourself and to your loved ones. Care instruction keep away from fire." ,"amazon_rating": 4.7,"release_date": "2019-05-09","tags": ["Software Architecture", "Functional Programming", "General Introduction to Programming"]}
 {"index":{"_index":"books","_id":"32"}}
 {"title": "Automate The Boring Stuff With Python", "author": "Al Sweigart","edition": 2,"synopsis": "Reading books is a kind of enjoyment. Reading books is a good habit. We bring you a different kinds of books. You can carry this book where ever you want. It is easy to carry. It can be an ideal gift to yourself and to your loved ones. Care instruction keep away from fire." ,"amazon_rating": 4.7,"release_date": "2019-10-17","tags": ["Software Architecture", "Functional Programming", "General Introduction to Programming"]}
 {"index":{"_index":"books","_id":"33"}}
 {"title": "Python Projects for Beginners", "author": "Connor P. Milliken","edition": 1,"synopsis": "Immerse yourself in learning Python and introductory data analytics with this book’s project-based approach. Through the structure of a ten-week coding bootcamp course, you’ll learn key concepts and gain hands-on experience through weekly projects." ,"amazon_rating": 4.7,"release_date": "2019-11-16","tags": ["Python language", "Python Data Analysis library", "Anaconda, Jupyter Notebooks, and the Python Shell"]}
 {"index":{"_index":"books","_id":"34"}}
 {"title": "Python All-in-One For Dummies", "author": "John C. Shovic and Alan Simpson","edition": 2,"synopsis": "Powerful and flexible, Python is one of the most popular programming languages in the world. It's got all the right stuff for the software driving the cutting-edge of the development world—machine learning, robotics, artificial intelligence, data science, etc. The good news is that it’s also pretty straightforward to learn, with a simplified syntax, natural-language flow, and an amazingly supportive user community." ,"amazon_rating": 4.3,"release_date": "2021-04-09","tags": ["Python Building Blocks", "Artificial Intelligence and Python", "Data Science and Python"]}
 {"index":{"_index":"books","_id":"35"}}
 {"title": "Learning Python", "author": "Mark Lutz ","edition": 1,"synopsis": "Get a comprehensive, in-depth introduction to the core Python language with this hands-on book. Based on author Mark Lutz’s popular training course, this updated fifth edition will help you quickly write efficient, high-quality code with Python. It’s an ideal way to begin, whether you’re new to programming or a professional developer versed in other languages." ,"amazon_rating": 4.5,"release_date": "2013-07-06","tags": ["Software quality", "Enjoyment", "Powerful Object-Oriented Programming"]}
 {"index":{"_index":"books","_id":"36"}}
 {"title": "Data Structure and Algorithmic Thinking with Python", "author": "Narasimha Karumanchi","edition": 1,"synopsis": "Data Structure and Algorithmic Thinking with Python is designed to give a jump-start to programmers, job hunters and those who are appearing for exams. All the code in this book are written in Python. It contains many programming puzzles that not only encourage analytical thinking, but also prepares readers for interviews. This book, with its focused and practical approach, can help readers quickly pick up the concepts and techniques for developing efficient and effective solutions to problems." ,"amazon_rating": 4.2,"release_date": "2015-01-29","tags": ["Algorithmic Programming", "Introduction to Programming", "Python Programming"]}
 {"index":{"_index":"books","_id":"37"}}
 {"title": "Python for Data Analysis", "author": "Wes Mckinney","edition": 2,"synopsis": "Get complete instructions for manipulating, processing, cleaning, and crunching datasets in Python. Updated for Python 3.6, the second edition of this hands-on guide is packed with practical case studies that show you how to solve a broad set of data analysis problems effectively. You’ll learn the latest versions of pandas, NumPy, IPython, and Jupyter in the process. " ,"amazon_rating": 4.6,"release_date": "2017-11-03","tags": ["pandas, NumPy, IPython, and Jupyter", "Python Programming", "Data Analytics"]}
 {"index":{"_index":"books","_id":"38"}}
 {"title": "Effective Pandas", "author": "Matt Harrison", "edition": 1, "synopsis": "Best practices for manipulating data with Pandas. This book will arm you with years of knowledge and experience that are condensed into an easy to follow format. Rather than taking months reading blogs and websites and searching mailing lists and groups, this book will teach you how to write good Pandas code." ,"amazon_rating": 4.9,"release_date": "2021-12-08","tags": ["Data Manipulation", "Visualization", "Programming Languages"]}
 {"index":{"_index":"books","_id":"39"}}
 {"title": "Python by Example", "author": "Terry Norton","edition": 1,"synopsis": "Python is today's fastest growing programming language. This engaging and refreshingly different guide breaks down the skills into clear step-by-step chunks and explains the theory using brief easy-to-understand language. Rather than bamboozling readers with pages of mind-numbing technical jargon, this book includes 150 practical challenges, putting the power in the reader's hands." ,"amazon_rating": 4.5,"release_date": "2019-06-06","tags": ["Introduction To Programming", "Python Programming"]}
 {"index":{"_index":"books","_id":"40"}}
 {"title": "Python Distilled", "author": "David Beazley","edition": 1,"synopsis": "The richness of modern Python challenges developers at all levels. How can programmers who are new to Python know where to begin without being overwhelmed? How can experienced Python developers know they're coding in a manner that is clear and effective? How does one make the jump from learning about individual features to thinking in Python at a deeper level? Dave Beazley's new Python Distilled addresses these and many other real-world issues." ,"amazon_rating": 4.7,"release_date": "2021-11-09","tags": ["Introduction To Programming", "Python Programming"]}
 {"index":{"_index":"books","_id":"41"}}
 {"title": "Kotlin Programming", "author": "Josh Skeen, Andrew Bailey and David Greenhalgh","edition": 1,"synopsis": "Kotlin is a statically typed programming language designed to interoperate with Java and fully supported by Google on the Android operating system. It is also a multiplatform language that can be used to write code that can be shared across platforms including macOS, iOS, Windows, and JavaScript." ,"amazon_rating": 5.0,"release_date": "2022-01-13","tags": ["Kotlin Essentials", "Kotlin concepts and foundational APIs"]}
v {"index":{"_index":"books","_id":"42"}}
 {"title": "Java to Kotlin", "author": "Duncan McGregor and Nat Pryce","edition": 1,"synopsis": "It takes a week to travel the 8,000 miles overland from Java to Kotlin. If you're an experienced Java developer who has tried the Kotlin language, you were probably productive in about the same time. " ,"amazon_rating": 5.0,"release_date": "2021-08-24","tags": ["Kotlin from scratch", "mixed language codebase"]}
 {"index":{"_index":"books","_id":"43"}}
 {"title": "Kotlin in Action", "author": "DDmitry Jemerov","edition": 1,"synopsis": "Kotlin is a new programming language targeting the Java platform. It offers on expressiveness and safety without compromising simplicity,seamless interoperability with existing Java code, and great tooling support. Because Kotlin generates regular Java bytecode and works together with existing Java libraries and frameworks, it can be used almost everywhere where Java is used today - for server-side development, Android apps, and much more." ,"amazon_rating": 4.7,"release_date": "2017-03-27","tags": ["IMobile Phone Programming", "Introduction to Programming
"]}
 {"index":{"_index":"books","_id":"44"}}
 {"title": "Head First Kotlin", "author": "Dawn Griffiths and David Griffiths","edition": 1,"synopsis": "This hands-on book helps you learn the Kotlin language with a unique method that goes beyond syntax and how-to manuals, and teaches you how to think like a great Kotlin developer. You ll learn everything from language fundamentals to collections, generics, lambdas, and higher-order functions." ,"amazon_rating": 4.4,"release_date": "2019-02-28","tags": ["Introduction To Programming", "Kotlin language"]}
 {"index":{"_index":"books","_id":"45"}}
 {"title": "Kotlin Cookbook", "author": "Ken Kousen","edition": 1,"synopsis": "Use Kotlin to build Android apps, web applications, and more—while you learn the nuances of this popular language. With this unique cookbook, developers will learn how to apply thisJava-based language to their own projects. Both experienced programmers and those new to Kotlin will benefit from the practical recipes in this book." ,"amazon_rating": 4.4,"release_date": "2019-11-22","tags": ["Introduction To Programming", "Mobile Phone Programming", "Android and Spring"]}
 {"index":{"_index":"books","_id":"46"}}
 {"title": "The Joy of Kotlin", "author": "Pierre-Yves Saumont Saumont","edition": 1,"synopsis": "The Joy of Kotlin teaches readers the right way to code in Kotlin. This insight-rich book covers everything needed to master the Kotlin language while exploring coding techniques that will make readers better developers no matter what language they use." ,"amazon_rating": 4.3,"release_date": "2019-05-20","tags": ["Introduction To Programming", "Safe handling of errors and exceptions", "Dealing with optional data"]}
 {"index":{"_index":"books","_id":"47"}}
 {"title": "Discovering Statistics Using R", "author": "Andy Field, Jeremy Miles and Zoe Field","edition": 1,"synopsis": "Discovering Statistics Using R takes students on a journey of statistical discovery using R, a free, flexible and dynamically changing software tool for data analysis that is becoming increasingly popular across the social and behavioural sciences throughout the world." ,"amazon_rating": 4.5,"release_date": "2012-03-22","tags": ["Programming Languages & Tools", "Psychological Methodology", "R Programming"]}
 {"index":{"_index":"books","_id":"48"}}
 {"title": "R for Data Science", "author": "Garrett Grolemund and Hadley Wickham","edition": 1,"synopsis": "What exactly is data science? With this book, you’ll gain a clear understanding of this discipline for discovering natural laws in the structure of data. Along the way, you’ll learn how to use the versatile R programming language for data analysis." ,"amazon_rating": 4.7,"release_date": "2016-07-25","tags": ["Data Wrangling", "Data Visualization", "Exploratory Data Analysis"]}
 {"index":{"_index":"books","_id":"49"}}
 {"title": "Geocomputation with R", "author": "Robin Lovelace, Jakub Nowosad and Jannes Muenchow","edition": 1,"synopsis": "Geocomputation with R is for people who want to analyze, visualize and model geographic data with open source software. It is based on R, a statistical programming language that has powerful data processing, visualization, and geospatial capabilities." ,"amazon_rating": 5.0,"release_date": "2019-03-21","tags": ["Geocomputation", "R Programming"]}
 {"index":{"_index":"books","_id":"50"}}
 {"title": "R Cookbook", "author": "Jd Long and Paul Teetor","edition": 1,"synopsis": "Perform data analysis with R quickly and efficiently with more than 275 practical recipes in this expanded second edition. The R language provides everything you need to do statistical work, but its structure can be difficult to master. These task-oriented recipes make you productive with R immediately. Solutions range from basic tasks to input and output, general statistics, graphics, and linear regression." ,"amazon_rating": 4.6,"release_date": "2019-07-12","tags": ["Data Analysis, Statistics, and Graphics", "R Programming"]}
```

## 1. `match` query

```json
# 搜索标题中包含"Java"的书籍
GET books/_search
{
  "query": {
    "match": {
      "title": "Java"
    }
  }
}

# 搜索标题中包含"Java Complete Guide"的书籍，并高亮显示匹配的部分
# Elasticsearch的全文搜索查询基于倒排索引，它会对输入的文本进行分词，然后对每个分词进行搜索。
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Java Complete Guide"
      }
    }
  },
  "highlight": {
    "fields": {
      "title": {}
    }
  }
}

# 与上述查询相同，但明确指定了OR运算符
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Java Complete Guide",
        "operator": "OR"
      }
    }
  }
}

# 明确指定AND运算符进行全文搜索
# 使用了"AND"运算符，这意味着所有的分词都必须在文档中出现，才会被视为匹配。
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Java Complete Guide",
        "operator": "AND"
      }
    }
  }
}

# 匹配至少两个词的查询
# 使用了"OR"运算符，并设置了"minimum_should_match"为2，这意味着至少有两个分词必须在文档中出现，才会被视为匹配。
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Java Complete Guide",
        "operator": "OR",
        "minimum_should_match": 2
      }
    }
  }
}

# 尝试匹配一个拼写错误的词"Kava"，因此不会有任何结果。
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Kava"
      }
    }
  }
}

# 尝试匹配一个拼写错误的词"Kava"，并设置"fuzziness"为1，这意味着允许有一个字符的差异，因此可以得到正面的结果。
GET books/_search
{
  "query": {
    "match": {
      "title": {
        "query": "Kava",
        "fuzziness": 1
      }
    }
  }
}
```

## 2. `multi_match` query

```json
# 在多个字段中搜索相同的词。尝试在"title"，"synopsis"和"tags"字段中匹配"Java"，任何字段中出现"Java"的文档都会被视为匹配。
GET books/_search
{
  "_source": false,
  "query": {
    "multi_match": {
      "query": "Java",
      "fields": [
        "title",
        "synopsis",
        "tags"
      ]
    }
  },
  "highlight": {
    "fields": {
      "title": {},
      "tags": {}
    }
  }
}

# 在多个字段中搜索相同的词，并返回匹配度最高的字段。尝试在"title"和"synopsis"字段中匹配"Design Patterns"，只有匹配度最高的字段的文档会被视为匹配。
GET books/_search
{
  "_source": false,
  "query": {
    "multi_match": {
      "query": "Design Patterns",
      "type": "best_fields",
      "fields": ["title","synopsis"]
    }
  }, "highlight": {
    "fields": {
      "tags": {},
      "title": {}
    }
  }
}

# 最佳字段匹配查询 - 使用平局分数解决器
# 支持最佳字段匹配查询，并可以使用"tie_breaker"参数来解决平局问题。试在"title"和"synopsis"字段中匹配"Design Patterns"，并设置"tie_breaker"为0.5，这意味着当多个字段的匹配度相同时，会考虑其他字段的匹配度来决定最终的匹配度。
# tie_breaker 参数用于处理多个字段匹配度相同的情况。它的值范围是 0 到 1。当 tie_breaker 的值为 0 时，只有最佳匹配的字段会计入得分。当 tie_breaker 的值为 1 时，所有字段的得分都会被计算在内。
# 文档1：
# title: "Design Patterns in Java"
# synopsis: "A comprehensive guide to Java design patterns."
# 文档2：
# title: "Java Programming"
# synopsis: "Design Patterns for Java developers."
# 在不使用 tie_breaker 的情况下，这两个文档的匹配度可能是相同的。但是，当我们设置 tie_breaker 为 0.3 时，文档1的得分可能会更高，因为它的"title"字段和"synopsis"字段都包含了查询词"Design Patterns"，而 tie_breaker 使得"synopsis"字段的得分也能部分地计入总得分
GET books/_search
{
  "_source": false,
  "query": {
    "multi_match": {
      "query": "Design Patterns",
      "type": "best_fields",
      "fields": ["title","synopsis"],
      "tie_breaker": 0.5
    }
  }, "highlight": {
    "fields": {
      "tags": {},
      "title": {}
    }
  }
}

# 在"title"和"tags"字段中匹配"C# guide"，并设置"title"字段的权重为2，这意味着"title"字段的匹配度会比"tags"字段的匹配度更重要。
GET books/_search
{
  "query": {
    "multi_match": {
      "query": "C# guide",
      "fields": ["title^2", "tags"]
    }
  }
}
```

## 3. `query_string` query

```json
# 在一个查询中使用多个条件并通过逻辑运算符（如 AND、OR）连接。在这个查询中，我们尝试匹配"author"字段为"Bert"，"edition"字段为2，并且"release_date"字段大于或等于"2000-01-01"的文档。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "author:Bert AND edition:2 and release_date>=2000-01-01"
    }
  }
}

# 在所有字段中匹配"Patterns"，并高亮显示"title"，"synopsis"和"tags"字段中的匹配项。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Patterns"
    }
  },
  "highlight": {
    "fields": {
      "title": {},
      "synopsis": {},
      "tags": {}
    }
  }
}

# 在"title"，"synopsis"和"tags"字段中匹配"Patterns"。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Patterns",
      "fields": ["title","synopsis","tags"]
    }
  }
}

# 在"title"字段中匹配"Design Patterns"，如果查询字符串中没有指定字段，那么将使用"title"作为默认字段。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Design Patterns",
      "default_field": "title"
    }
  }
}

# 在 "title" 字段中搜索包含 "Design Patterns" 的书籍。"AND" 操作符表示 "Design" 和 "Patterns" 这两个词必须同时出现在 "title" 字段中。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Design Patterns",
      "default_field": "title",
      "default_operator": "AND"
    }
  }
}

# 在 "synopsis" 字段中搜索精确匹配 "making the code better" 这个短语的书籍。双引号表示精确匹配，即 "making the code better" 必须作为一个整体出现在 "synopsis" 字段中。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "\"making the code better\"",
      "default_field": "synopsis"
    }
  }
}

# 在 "synopsis" 字段中搜索精确匹配 "making code better" 这个短语的书籍。"phrase_slop" 参数设置为1，表示 "making", "code", "better" 这三个词之间可以有1个词的距离，例如 "making the code better" 也会被匹配。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "\"making code better\"",
      "default_field": "synopsis",
      "phrase_slop": 1
    }
  }
}

# 在 "title" 字段中进行模糊搜索 "Pattenrs"。末尾的波浪线表示启用模糊搜索，即允许关键词有一定的拼写错误，例如 "Patterns" 也会被匹配。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Pattenrs~",
      "default_field": "title"
    }
  }
}

# 在 "title" 字段中进行模糊搜索 "Pattenrs"。末尾的波浪线后的数字1表示启用模糊搜索，并且编辑距离为1，即允许关键词有1个字符的拼写错误，例如 "Patterns" 也会被匹配。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "Pattenrs~1",
      "default_field": "title"
    }
  }
}


# 在 "title" 字段中进行模糊搜索 "tterns"。末尾的波浪线表示启用模糊搜索，编辑距离默认为2，即允许关键词有2个字符的拼写错误，例如 "Patterns" 也会被匹配。如果需要减少编辑距离，可以在波浪线后设置为1，例如 "tterns~1"。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "tterns~",
      "default_field": "title"
    }
  }
}

# 查询是非法的，因为在 "query" 参数中使用了双冒号 "::"。在 Elasticsearch 中，应该使用单冒号 ":" 来指定字段，例如 "title:Java"。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "title::Java "
    }
  }
}

# 查询也是非法的，因为在 "query" 参数中的 "title:Java""，双引号没有被正确地配对。在 Elasticsearch 中，如果你想要搜索包含特殊字符的字符串，你需要确保特殊字符被正确地配对，例如 "title:\"Java\""。
GET books/_search
{
  "query": {
    "query_string": {
      "query": "title:Java\""
    }
  }
}
```

## 4. `simple_query_string` query

```json
# 搜索包含 "Java" 和 "Cay" 的文档。"+" 操作符表示 "Java" 和 "Cay" 这两个词必须同时出现。simple_query_string 查询相比于 query_string 查询更加宽松，它会忽略语法错误，而不是抛出异常。
GET books/_search
{
  "query": {
    "simple_query_string": {
      "query": "Java + Cay"
    }
  }
}

# 搜索 "title" 字段中包含 "Java" 的文档。虽然 "query" 参数中的 "title:Java"" 的双引号没有被正确地配对，但是 simple_query_string 查询会忽略这个错误，而不是抛出异常。这是 simple_query_string 查询相比于 query_string 查询的一个优点。
GET books/_search
{
  "query": {
    "simple_query_string": {
      "query": "title:Java\""
    }
  }
}

# 在 "title" 和 "synopsis" 这两个字段中搜索包含 "Java" 的文档。"fields" 参数用于指定搜索的字段，你可以在这里列出所有你想要搜索的字段。
GET books/_search
{
  "query": {
    "simple_query_string":{
      "query":"Java",
      "fields":["title","synopsis"]
    }
  }
}
```

## 5. `match_phrase` query

```json
# 精确匹配一整个短语。尝试匹配短语"book for every Java programmer"，只有当这个短语完全出现在synopsis字段中时，文档才会被视为匹配。
GET books/_search
{
  "query": {
    "match_phrase": {
      "synopsis": "book for every Java programmer"
    }
  }
}

# 使用slop的短语查询，可以处理短语中的词序和词间距问题。匹配短语"book every Java programmer"，并设置"slop"为1，这意味着允许短语中的词之间有一个词的距离，因此即使短语中缺少一个词，也可以得到正面的结果。
GET books/_search
{
  "query": {
    "match_phrase": {
      "synopsis": {
       "query": "book every Java programmer",
       "slop": 1
      }
    }
  }
}

# 即使设置了"slop"，如果短语中的词序完全混乱，如"for every Java programmer book"，仍然无法匹配到结果。
GET books/_search
{
  "query": {
    "match_phrase": {
      "synopsis": {
       "query": "for every Java programmer book",
       "slop": 1
      }
    }
  }
}
```

## 6. `match_bool_prefix` query

## 7. `match_phrase_prefix` query

```json
# 匹配以特定短语开始的文本。尝试匹配以"concepts and found"开始的tags字段，只有当这个短语是tags字段的前缀时，文档才会被视为匹配。
GET books/_search
{
  "query": {
    "match_phrase_prefix": {
      "tags": {
        "query": "concepts and found"
      }
    }
  },
  "highlight": {
    "fields": {
      "tags": {}
    }
  }
}

# 使用slop的匹配短语前缀查询，可以处理短语中的词序和词间距问题。尝试匹配以"concepts found"开始的tags字段，并设置"slop"为1，这意味着允许短语中的词之间有一个词的距离，因此即使短语中省略了"and"，也可以得到正面的结果。
GET books/_search
{
  "query": {
    "match_phrase_prefix": {
      "tags": {
        "query": "concepts found",
        "slop":1
      }
    }
  }
}
```

## 8 `combined_fields` query

```json
# 在 "title" 和 "synopsis" 这两个字段中搜索包含 "Java" 的文档。"fields" 参数用于指定搜索的字段，你可以在这里列出所有你想要搜索的字段。combined_fields 查询会将所有字段的值组合在一起，然后对这个组合的值进行搜索。
GET books/_search
{
  "query": {
    "combined_fields":{
      "query":"Java",
      "fields":["title","synopsis"]
    }
  }
}
```

## 9. `intervals` query

## 总结

Elasticsearch 的全文搜索主要包括以下特性：

1. Elasticsearch 擅长使用全文查询搜索非结构化数据。全文查询会产生相关性，这意味着匹配并返回的文档有一个正的相关性得分。

2. Elasticsearch 提供了一个 \_search API 用于查询。

3. 当使用相关性搜索全文时，有几种类型的匹配查询适用于各种用例。最常见的查询是匹配查询。

4. 匹配查询在文本字段上搜索搜索条件，并使用相关性算法对文档进行评分。

5. 匹配所有（match_all）查询在所有索引上搜索，并且不需要主体。

6. 要搜索短语，我们使用 match_phrase 查询或其变体 match_phrase_prefix。这两种类型的查询都让我们能够按照定义的顺序搜索特定的单词。此外，如果短语缺少单词，我们可以使用 phrase_slop 参数。

7. 使用 multi_match 查询可以在多个字段上搜索用户的条件。

8. 查询字符串（query_string）查询使用逻辑运算符，如 AND、OR 和 NOT。然而，query_string 查询对语法要求严格，所以如果输入的语法不正确，我们会收到一个异常。

9. 如果我们需要 Elasticsearch 对查询字符串的语法要求不那么严格，那么我们可以使用 simple_query_string 查询，而不是使用 query_string 查询。使用这种查询类型，所有的语法错误都会被引擎抑制。
