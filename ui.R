library(ggplot2)


dataurl="http://www.statsci.org/data/oz/ctsibuni.txt"
ctsib=read.table("http://www.statsci.org/data/oz/ctsibuni.txt",sep="\t",header=TRUE)

shinyUI(navbarPage("Project 2 - Min Chen",
                   tabPanel("Introduction",
                            mainPanel(
                              
                              h2("Creating a Shiny App"),
                              p("The goal of this project is to create a nice looking shiny app"),
                              h2("Find a data set you are interested in"),
                              p("For this project I'm going to let you choose your own data set. This should be a data set that has at least
two categorical and at least two quantitive variables. See the previous project for a list of places with data
sets. Alternatively, you could pull data from the web within your app (for instance baseball data (link) or
twitter data (link))
                                Choose something you are interested in! We are going to create a shiny app (see specifications below) and
later we will add some predictive modeling to the app."),
                              h2("App Requirements"),
                              HTML("<ul><li>Your app should have multiple pages to it. This should include an information page, two pages - each
                              with at least one graph, and a page that allows the user to scroll through the data (or subset of data of
                              interest). I don't care if you use the built in tabs for shiny or a package like shinydashboard, use the
                              method you prefer.</li>
                                   <li> You should have at least two different dynamic UI elements.</li>
                                   <li> You should have a button that allows the user to save a plot they are viewing to a file.</li>
                                   <li> You should have an option to allow the user to save the data currently being used for a plot (or when they are looking at the data table) to a .csv (or other) file.</li>
                                   <li> You should utilize the ability to click on a plot or select a region in some way.</li>
                                   <li> You should include some type of math type (maybe an equation or just a special symbol you need to use mathJax for).</li>
                              
                                    <li>You should include a link to something and some other formatted text.</li>
                                <ul>"))),
                   # Application title
                   tabPanel("Exploration of the ctsib data",
              # Sidebar with options for the data set
              sidebarLayout(
                sidebarPanel(
                  h3("Select the Vision:"),
                  selectizeInput("Vision", "Vision", selected = "open", choices = levels(as.factor(ctsib$Vision))),
                  br(),
                  h3("Select the Surface:"),
                  selectizeInput("Surface", "Surface", selected = "norm", choices = levels(as.factor(ctsib$Surface))),
                  br(),
                  h3("Select the Gender:"),
                  selectizeInput("Sex", "Sex", selected = "all", choices = c(levels(as.factor(ctsib$Sex )),"all")),
                  br(),
                  checkboxInput("hideplot", h4("Hide the plot")),
                  
                  sliderInput("size", "Size of Points on Graph",
                              min = 1, max = 10, value = 3, step = 1),
                  conditionalPanel(condition = "input.Sex == 'all'",
                                   
                  withMathJax(helpText("assume we have $$\\alpha$$ of female, and $$\\beta$$ male, then total will be $$\\alpha+\\beta$$")),
                                   
                  checkboxInput("conservation", h4("Color Code based on gender (only shows when all is selected)", style = "color:red;"))
                  )
                ),
                # Show output
                mainPanel(
                  helpText(a("Click Here to see my datasource",href="http://www.statsci.org/data/oz/ctsibuni.txt")
                  ),
                  conditionalPanel(condition = "input.hideplot == false",
                    downloadButton('downloadPlot', 'Download Plot'),
                  plotOutput("ctsibPlot")),
                  downloadButton("downloadData", "Download"),
                  tableOutput("table")
                )
              )
            )
))
