#document("index.html")[
  #title[*Wannes* Malfait]

  #link(<links>)[Contact info and relevant links]
  #sym.dot
  #link(<blog>)[Go to blog]
  #sym.dot
  #link(<news>)[News]


  #image("./assets/prof_pic.png", width: 30%, alt: "A simple sketch of myself")
  = About me

  Hi! I'm Wannes, a PhD student in mathematics at the VUB. Besides mathematics, I'm interested in music, chess, programming, reading, ultimate frisbee, and more. You can navigate to relevant pages using the links at the top of the website.

  Let me say a bit more about each of the interests listed above:

  - *Mathematics.* My interests vary quite a bit, but category theory, algebra, functional analysis, and representation theory are the main ones. I'm currently working on cluster algebras, positive representations and quantum groups.
  - *Music.* I like listening to soundtracks of films or games. Favorites include the soundtracks of Interstellar, The Octopath Traveller, Celeste,  and Ori and the Will of the Wisps. I am somewhat capable at playing the clarinet (classical music not jazz).
  - *Chess.* I have liked playing chess since I was a kid, but have only played in a club for a few years. You can challenge me on #link("https://lichess.org/@/Boris-Beauty-Gelfand", [lichess]). I don't play that much, but I do keep up to date with the latest chess news, and chess engine news.
  - *Programming.* This is one of my biggest hobbies. I have enough projects in my backlog to keep me busy full time. A big part of my free time is spent contributing to #link("https://www.blender.org", [Blender]): to the main source code, and to some add-ons that I created. Other than that, I am interested in chess engines and, more generally, using computers to analyze board games.
  - *Reading.* My favorite genres are definitely fantasy and science fiction. Some of my favorite series include: The Wheel of Time, The Stormlight Archive, Dune, The Farseer trilogy, The Ranger's Apprentice and Ender's Game.
  - *Ultimate Frisbee*. My first introduction to this sport was in high school, where we played with a few friends after school. I now play in a small club in Brussels. The positive attitude and spirit of the players is something you don't find in many other sports.

  = Where to find me

  Most of the time you will find me at the VUB. Below you can find an (incomplete) list of days when I am not there.

  #let date-format = "[day]/[month]/[year]"
  #let conf-link(linkstr) = [#sym.dot #link(linkstr)[link] #sym.dot]
  == Upcoming
  - *VUB-Leeds Algebra School* #conf-link("https://vubleedstopyb.github.io/summer-school/index.html") (#datetime(day: 8, month: 6, year: 2026).display(date-format) - #datetime(day: 12, month: 6, year: 2026).display(date-format)) Participant
  - *ITMAIA 2026, Leeds* #conf-link("https://sites.google.com/view/itmaia2026/home") (#datetime(day: 15, month: 04, year: 2026).display(date-format) - #datetime(day: 17, month: 04, year: 2026).display(date-format)) Talk: "Generating a C\*-algebra"
  == Past
  - *MPI-MIS Leipzig* #conf-link("https://www.mis.mpg.de/geometry-groups-dynamics") (#datetime(day: 12, month: 1, year: 2026).display(date-format) - #datetime(day: 16, month: 1, year: 2026).display(date-format)) Research visit and talk in Geometry seminar
  - *CARE 2025, Lyon* #conf-link("https://sites.google.com/uniroma1.it/caremath/home-page") (#datetime(day: 27, month: 10, year: 2025).display(date-format) - #datetime(day: 31, month: 10, year: 2025).display(date-format)) Talk: "Cluster algebras from the perspective of operator algebras"
  - *CAMP in the Lakes, Ambleside* #conf-link("https://sites.google.com/view/campinthelakes") (#datetime(day: 14, month: 7, year: 2025).display(date-format) - #datetime(day: 23, month: 7, year: 2025).display(date-format)) Participant
  - *Cluster Geometry, Nordfjordeid* #conf-link("https://www.mn.uio.no/math/english/research/groups/algebra/events/conferences/nordfjordeid2025/") (#datetime(day: 9, month: 6, year: 2025).display(date-format) - #datetime(day: 13, month: 6, year: 2025).display(date-format)) Participant
  - *Algebra Days 2025, Caen* #conf-link("https://mdpressland.github.io/events/AlgebraDays25.html") (#datetime(day: 18, month: 3, year: 2025).display(date-format) - #datetime(day: 19, month: 3, year: 2025).display(date-format)) Participant
  - *Higher structures in Noncommutative Geometry and Quantum Algebra, Lille* #conf-link("https://www.mathconf.org/hsngqa2024") (#datetime(day: 8, month: 10, year: 2024).display(date-format) - #datetime(day: 11, month: 10, year: 2024).display(date-format)) Participant

  = News <news>
  - *November 1, 2024*: Started my PhD
  - *May 21, 2024*: #link(<news:finished_thesis>)[Submitted my Master's thesis]
  - *Feb 17, 2024*: I created a website

  = Contact info <links>
  - #link("mailto:wannes.malfait@vub.be")[E-mail]
  - #link("https://orcid.org/0009-0009-2626-7356")[ORCID]
  - #link("https://github.com/wannesmalfait")[GitHub]
  - #html.elem("a", attrs: (href: "https://mathstodon.xyz/@WannesMalfait", rel: "me"))[Mathstodon]
  - #link("https://youtube.com/@WannesMalfait")[YouTube]

  #html.elem("p", attrs: (style: "margin-top:20cm;"))[
    #emoji.duck Congrats, you made it to the bottom of the page!
  ]

]<about>

#document("news/finished_thesis.html")[
  #include "./_news/finished_thesis.typ"
]<news:finished_thesis>

#document("blog.html")[
  #title[Blog]

  #link(<about>)[Back to about page]

  = Latest posts
  - *Jun 05, 2024*: #link(<blog:parallel-primes>)[Computing prime numbers in parallel]
  - *Mar 16, 2024*: #link(<blog:github-latex-ci>)[LaTeX compilation with GitHub actions]

]<blog>

#document("/blog/2024/parallel-primes.html")[
  - #link(<about>)[Back to about page]
  - #link(<blog>)[Back to blog]
  #include "./_posts/2024-06-05-parallel-primes.typ"
]<blog:parallel-primes>

#document("/blog/2024/github-latex-ci.html")[
  - #link(<about>)[Back to about page]
  - #link(<blog>)[Back to blog]
  #include "./_posts/2024-03-16-github-latex-ci.typ"
]<blog:github-latex-ci>

#asset("favicon.ico", read("./assets/favicon.ico", encoding: none))
