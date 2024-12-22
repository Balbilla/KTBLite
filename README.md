# KTB-lite

## Contents:
- Intro 
- Corpora in KTB-lite
- First time installation 
- Instructions for using the search
- Quickstart


## Intro

This is the lite version of the [KTB platform](https://gitlab.com/polinayordanova/treebanking).

KTB is a tool for data management, processing and manipulation, and querying of XML based morpho-syntactically annotated (treebanked) corpora. It has been developed by Polina Yordanova and Jamie Norrish on the basis of the [Kiln platform](https://kiln.readthedocs.io/en/latest/projects.html), for the research purposes of Yordanova's doctoral project.  In its specification as a search platform for Ancient Greek treebanks created within the AGDT framework, it has a generalised search, allowing a non-technically prepared user to search for the main features from the AGDT annotation scheme, and additional annotations built on the basis of those features allowing for more complicated queries. The searching functionalities in the lite version are are organised in three levels:
- Document search
- Sentence search
- Word search

## Corpora in KTB-lite

The treebanked corpora that currently make up the content of KTB-lite are:
- papygreek - the corpus prepared within the Digital Grammar of Greek Documentary Papyri project https://papygreek.com/ ;
- papygreek_letters - a subset of PapyGreek's collection containing only letters;
- duke_letters - automatically annotated data from DDbDP, prepared by Alek Keersmaekers https://github.com/alekkeersmaekers/duke-nlp/blob/master/README.md . The version of the corpus housed in KTB-lite has been downloaded in 2022 and contains the letters that are found in both PapyGreek’s and Duke-nlp’s collections;
- literature_prose - a compound corpus made up of AGDT's https://perseusdl.github.io/treebank_data/  prose authors and Vanessa Gorman's trees https://perseids-publications.github.io/gorman-trees/ ;
- literature_verse - AGDT's verse authors plus Sappho, prepared within the PEDALION project https://en.pedalion.org/about, and Balbilla, annotated by Gabriel Bodard and Marja Vierros in PapyGreek's platform .

## First time installation:

Start by checking what version of Java you are running: open your Command Prompt / Terminal and type in “java -version”. My system is using 15; any of the recent ones should work too, but if at any point during the following steps you encounter a Java error, you might need to uninstall the version you’re currently using and install 15 instead.

If you are working on a Mac, you should also have wget - here are some instructions how to install it https://www.fossmint.com/install-and-use-wget-on-mac/  

Installation steps:

1. Clone or download KTB-lite from the repository https://gitlab.com/polinayordanova/ktb-lite. If you downloaded the ZIP, you will need to unzip it before you can do anything with it. Remember which directory you are putting it in; I’d recommend you put it on the Desktop if you have enough space, while you get used to the whole procedure.

2. In your Command prompt/Terminal navigate to the directory where KTB-lite is. The command to change directory is “cd” and the “path” that leads to the directory. Then press Enter. The folder containing the whole platform is called “ktb-lite”, so if you put it on the Desktop, it would look like this:


- For Windows: 
cd Desktop\ktb-lite

- For Mac:
cd Desktop/ktb-lite

(the only difference here being the direction of the slash - forward for Windows and backward for Mac; keep in mind that it is case sensitive)

3. Start the server that runs the platform by typing in the following and pressing Enter:

- For Windows:
build.bat

- For Mac:
sh build.sh

Wait until the message “Development server is running at http://127.0.0.1:9999. Quit the server with CONTROL-C.” shows up. 

NB! This needs to be running the whole time while you are using the platform! You can just minimize it to get it out of the way, but don’t close the window.

4. Go to http://127.0.0.1:9999 in your browser. Once you are seeing the home page with the Corpus selection and the Menu, you are ready for indexing.

5. For indexing: open *another* Command Prompt/Terminal window. Once again follow the instructions from step 2 to navigate to the folder containing the platform.

6. To index:

- If you want to index everything:

  
  - For Windows: build.bat solr

  - For Mac: sh build.sh solr

- If you only want to index a single corpus:
  - For Windows: build.bat index
  - For Mac: sh build.sh index

(then, when you are prompted by the terminal, enter the desired corpus directory)

Indexing of all corpora takes about 5 hours, so my advice is to do it overnight. Once you have indexed all the documents, the Command Prompt/Terminal will have returned into its initial state where it allows you to type in another command and that’s how you know the procedure has finished successfully. You only ever need to do indexing once.

Now you are ready to start having fun with the lite version of KTB! The home page with the Corpus Selection is mostly for summary and overview purposes, querying is now done through the searches in the menu tab.

## Instructions for using the Search:

By default, the field where you type in the word you are searching for works with the lemma. If you want to type in a particular form instead, you need to tick the Search word forms box first.
Always use the Facets first! Make sure to have set as many parameters from your search in the facets as possible, since this will change the numbers displayed and it will give you a more exact overview. Only use the table column filter once you are sure you have all the important query parameters set in place in the facets.
You can reorder the results in the table by clicking on the title of the column (for example, to order forward or backwards alphabetically, or to bring up the rows that actually have a result in that column).
The hyperlink in the Text tab takes you to the sentence containing this particular word and its tree.

## Quickstart (for every time you want to be using KTB-lite from now on):

Open the Command Prompt / Terminal and cd to the directory where you put KTB-lite.
(e.g. cd Downloads/ktb-lite)
Type in “build.bat” or “./build.sh” and press Enter. Wait until the message “Development server is running at http://127.0.0.1:9999. Quit the server with CONTROL-C.” shows up.
Go to http://127.0.0.1:9999/ and follow the links from there.
In order to close the platform, just close the Command Prompt / Terminal.
