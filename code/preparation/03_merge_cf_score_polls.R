#-------------------------------------------------------------------------------
#
# Electoral predictors - Merge US Senate polls 1990-2022 with Bonica's cf scores
#
# Source: 538, Bonica
# Author: Sina Chen
#
#-------------------------------------------------------------------------------


# Libraries ---------------------------------------------------------------

library(tidyverse)


# Data --------------------------------------------------------------------

# polls
polls <- readRDS("data/polls/us_senate_1990_2022_finance.RDS")

# scores
cf_scores <- read.csv("data/election_features/dime_recipients_1979_2020.csv")


#-------------------------------------------------------------------------------

# Pre-processing ----------------------------------------------------------

# candidate names in polls
poll_names <- polls %>% 
  select(candidate_name_dem, candidate_name_rep, cycle) %>% 
  gather(key = party, value = candidate_name, 
         candidate_name_dem:candidate_name_rep) %>% 
  mutate(candidate_name = candidate_name %>% 
           tolower() %>% 
           str_replace_all(" van ", " van") %>% 
           str_remove_all("\\s+iii|[,]"),
         candidate_name =  case_when(candidate_name == "pipkin" ~ "e pipkin",
                     TRUE ~ candidate_name),
         party = str_remove_all(party, "candidate_name_")) %>% 
  distinct() %>% 
  extract(candidate_name, into = c('fname', 'lname'), '(.*)\\s+([^ ]+)$',
          remove = F) 

# scores
scores <- cf_scores %>% 
  filter(seat == "federal:senate" &
           !(lname == "orourke" & cycle == 2020) & 
           !(lname == "campbell" & fname == "ben" &  party == 200) |
           (seat == "federal:house" & lname == "jeffords")) %>%
  select(fecyear, recipient.cfscore, party, lname, fname) %>% 
  filter(!is.na(recipient.cfscore)) %>% mutate(across(where(is.character), ~ na_if(.x, ""))) %>% 
  distinct() %>% 
  rename(cycle = fecyear) %>% 
  mutate(fname = case_when(lname == "giannoulias" & fname == "alexander" ~ "alexi", 
                           lname == "grimes" & fname == "alison" ~ "alison lundergan", 
                           lname == "damato" & fname == "alfonse" ~ "al", 
                           lname == "sanders" & fname == "alexander" ~ "alex", 
                           lname == "raczkowski" & fname == "andrew" ~ "andrew rocky", 
                           lname == "radnofsky" & fname == "barbara" ~ "barbara ann", 
                           lname == "hinckley" & fname == "benjamin" ~ "barry", 
                           lname == "cardin" & fname == "benjamin" ~ "ben", 
                           lname == "nelson" & fname == "e benjamin" ~ "ben", 
                           lname == "campbell" & fname == "ben" ~ "ben nighthorse", 
                           lname == "sasse" & fname == "benjamin" ~ "ben", 
                           lname == "orourke" & fname == "robert" ~ "beto", 
                           lname == "brock" & fname == "william" ~ "bill", 
                           lname == "frist" & fname == "william" ~ "bill", 
                           lname == "lloyd" & fname == "william" ~ "bill", 
                           lname == "schuette" & fname == "william" ~ "bill", 
                           lname == "bennett" & fname == "robert" ~ "bob", 
                           lname == "casey" & fname == "robert" ~ "bob", 
                           lname == "franks" & fname == "robert" ~ "bob", 
                           lname == "conley" & fname == "robert" ~ "bob", 
                           lname == "corker" & fname == "robert" ~ "bob", 
                           lname == "hugin" & fname == "robert" ~ "bob", 
                           lname == "inglis" & fname == "robert" ~ "bob", 
                           lname == "kasten" & fname == "robert" ~ "bob", 
                           lname == "kerrey" & fname == "j robert" ~ "bob", 
                           lname == "menendez" & fname == "robert" ~ "bob", 
                           lname == "packwood" & fname == "robert" ~ "bob", 
                           lname == "schaffer" & fname == "robert" ~ "bob", 
                           lname == "tuke" & fname == "robert" ~ "bob", 
                           lname == "hutto" & fname == "charles" ~ "brad", 
                           lname == "braun" & fname == "carol" ~ "carol moseley", 
                           lname == "masto" & fname == "catherine" ~ "catherine cortez", 
                           lname == "crist" & fname == "charles" ~ "charlie", 
                           lname == "farley" & fname == "chele" ~ "chele chiavacci", 
                           lname == "pingree" & fname == "rochelle" ~ "chellie", 
                           lname == "coons" & fname == "christopher" ~ "chris", 
                           lname == "dodd" & fname == "christopher" ~ "chris", 
                           lname == "murphy" & fname == "christopher" ~ "chris", 
                           lname == "rothfuss" & fname == "christopher" ~ "chris", 
                           lname == "grassley" & fname == "charles" ~ "chuck", 
                           lname == "hagel" & fname == "charles" ~ "chuck", 
                           lname == "haytaian" & fname == "garabed" ~ "chuck", 
                           lname == "groutage" & fname == "f dale" ~ "dale", 
                           lname == "coats" & fname == "daniel" ~ "dan", 
                           lname == "coats" & fname == "daniel" ~ "dan", 
                           lname == "moynihan" & fname == "daniel" ~ "daniel patrick", 
                           lname == "domina" & fname == "david" ~ "dave", 
                           lname == "fischer" & fname == "debra" ~ "deb", 
                           lname == "rehberg" & fname == "dennis" ~ "denny", 
                           lname == "durbin" & fname == "richard" ~ "dick", 
                           lname == "nickles" & fname == "donald" ~ "don", 
                           lname == "lamm" & fname == "dorothy" ~ "dottie", 
                           lname == "forrester" & fname == "douglas" ~ "doug", 
                           lname == "flanagan" & fname == "edward" ~ "ed", 
                           lname == "gillespie" & fname == "edward" ~ "ed", 
                           lname == "bernstein" & fname == "ed" ~ "edward", 
                           lname == "flanagan" & fname == "edward" ~ "ed", 
                           lname == "ganske" & fname == "john" ~ "greg", 
                           lname == "furman" & fname == "harold" ~ "hal", 
                           lname == "lonsdale" & fname == "harold" ~ "harry", 
                           lname == "carter" & fname == "john" ~ "jack", 
                           lname == "conway" & fname == "john" ~ "jack", 
                           lname == "markey" & fname == "edward" ~ "ed", 
                           lname == "lightfoot" & fname == "james" ~ "james ross", 
                           lname == "stoney" & fname == "janice" ~ "jan", 
                           lname == "nixon" & fname == "jeremiah" ~ "jay", 
                           lname == "bell" & fname == "jeffrey" ~ "jeff", 
                           lname == "beatty" & fname == "jeffrey" ~ "jeff", 
                           lname == "clark" & fname == "william" ~ "jeff", 
                           lname == "merkley" & fname == "jeffrey" ~ "jeff", 
                           lname == "barksdale" & fname == "james" ~ "jim", 
                           lname == "demint" & fname == "james" ~ "jim", 
                           lname == "durkin" & fname == "james" ~ "jim", 
                           lname == "huffman" & fname == "james" ~ "jim", 
                           lname == "inhofe" & fname == "james" ~ "jim", 
                           lname == "jeffords" & fname == "james" ~ "jim", 
                           lname == "martin" & fname == "james" ~ "jim", 
                           lname == "newberger" & fname == "james" ~ "jim", 
                           lname == "oberweis" & fname == "james" ~ "jim", 
                           lname == "rappaport" & fname == "james" ~ "jim", 
                           lname == "renacci" & fname == "james" ~ "jim", 
                           lname == "risch" & fname == "james" ~ "jim", 
                           lname == "sasser" & fname == "james" ~ "jim", 
                           lname == "talent" & fname == "james" ~ "jim",
                           lname == "webb" & fname == "james" ~ "jim",
                           lname == "biden" & fname == "joseph" ~ "joe",
                           lname == "donnelly" & fname == "joseph" ~ "joe",
                           lname == "hoeffel" & fname == "joseph" ~ "joe",
                           lname == "kyrillos" & fname == "joseph" ~ "joe",
                           lname == "lieberman" & fname == "joseph" ~ "joe",
                           lname == "sestak" & fname == "joseph" ~ "joe",
                           lname == "isakson" & fname == "john" ~ "johnny",
                           lname == "carroll" & fname == "john" ~ "john stanley",
                           lname == "brennan" & fname == "joseph" ~ "joseph edward",
                           lname == "hawley" & fname == "joshua" ~ "josh",
                           lname == "heath" & fname == "josephine" ~ "josie",
                           lname == "mcginty" & fname == "kathleen" ~ "kathleen alana",
                           lname == "hutchison" & fname == "kay" ~ "kay bailey",
                           lname == "buck" & fname == "kenneth" ~ "ken",
                           lname == "bond" & fname == "christopher" ~ "kit",
                           lname == "faircloth" & fname == "duncan" ~ "lauch",
                           lname == "weinberg" & fname == "lois" ~ "lois combs",
                           lname == "hassan" & fname == "margaret" ~ "maggie",
                           lname == "hatfield" & fname == "mark" ~ "mark odom",
                           lname == "nunn" & fname == "mary" ~ "mary michelle",
                           lname == "fong" & fname == "matthew" ~ "matt",
                           lname == "silverstein" & fname == "matthew" ~ "matt",
                           lname == "cleland" & fname == "joseph" ~ "max",
                           lname == "bouchard" & fname == "michael" ~ "mike",
                           lname == "crapo" & fname == "michael" ~ "mike",
                           lname == "enzi" & fname == "michael" ~ "mike",
                           lname == "espy" & fname == "michael" ~ "mike",
                           lname == "johanns" & fname == "michael" ~ "mike",
                           lname == "mcfadden" & fname == "michael" ~ "mike",
                           lname == "mcgavick" & fname == "michael" ~ "mike",
                           lname == "taylor" & fname == "michael" ~ "mike",
                           lname == "romney" & fname == "w mitt" ~ "mitt",
                           lname == "mitchell" & fname == "briane" ~ "nels",
                           lname == "cleland" & fname == "joseph" ~ "max",
                           lname == "ashdown" & fname == "peter" ~ "pete",
                           lname == "coors" & fname == "peter" ~ "pete",
                           lname == "hoekstra" & fname == "peter" ~ "pete",
                           lname == "bredesen" & fname == "philip" ~ "phil",
                           lname == "mountjoy" & fname == "richard" ~ "richard dick",
                           lname == "swett" & fname == "dick" ~ "richard",
                           lname == "gramm" & fname == "william" ~ "phil",
                           lname == "berg" & fname == "richard" ~ "rick",
                           lname == "noriega" & fname == "richard" ~ "rick",
                           lname == "santorum" & fname == "richard" ~ "rick",
                           lname == "portman" & fname == "robert" ~ "rob",
                           lname == "crumpton" & fname == "ronald" ~ "ronald steven",
                           lname == "johnson" & fname == "ronald" ~ "ron",
                           lname == "kirk" & fname == "ronald" ~ "ron",
                           lname == "klink" & fname == "ronald" ~ "ron",
                           lname == "sims" & fname == "ronald" ~ "ron",
                           lname == "boschwitz" & fname == "rudolph" ~ "rudy",
                           lname == "feingold" & fname == "russell" ~ "russ",
                           lname == "baesler" & fname == "henry" ~ "scotty",
                           lname == "capito" & fname == "shelley" ~ "shelley moore",
                           lname == "abraham" & fname == "edmond" ~ "spencer",
                           lname == "beshear" & fname == "steven" ~ "steve",
                           lname == "daines" & fname == "steven" ~ "steve",
                           lname == "lewis" & fname == "stephen" ~ "steve",
                           lname == "pearce" & fname == "stevan" ~ "steve",
                           lname == "sauerberg" & fname == "steven" ~ "steve",
                           lname == "sydness" & fname == "steven" ~ "steve",
                           lname == "thurmond" & fname == "james" ~ "strom",
                           lname == "duckworth" & fname == "l tammy" ~ "tammy",
                           lname == "celeste" & fname == "theodore" ~ "ted",
                           lname == "cruz" & fname == "rafael" ~ "ted",
                           lname == "kennedy" & fname == "edward" ~ "ted",
                           lname == "muenster" & fname == "theodore" ~ "ted",
                           lname == "land" & fname == "terri" ~ "terri lynn",
                           lname == "considine" & fname == "terrence" ~ "terry",
                           lname == "sanford" & fname == "james" ~ "terry",
                           lname == "cochran" & fname == "william" ~ "thad",
                           lname == "hutchinson" & fname == "y tim" ~ "tim",
                           lname == "kaine" & fname == "timothy" ~ "tim",
                           lname == "scott" & fname == "timothy" ~ "tim",
                           lname == "allen" & fname == "thomas" ~ "tom",
                           lname == "bruggere" & fname == "thomas" ~ "tom",
                           lname == "carper" & fname == "thomas" ~ "tom",
                           lname == "coburn" & fname == "thomas" ~ "tom",
                           lname == "cotton" & fname == "thomas" ~ "tom",
                           lname == "daschle" & fname == "thomas" ~ "tom",
                           lname == "harkin" & fname == "thomas" ~ "tom",
                           lname == "hartnett" & fname == "thomas" ~ "tommy",
                           lname == "strickland" & fname == "thomas" ~ "tom",
                           lname == "sullivan" & fname == "p tom" ~ "tom",
                           lname == "figures" & fname == "vivian" ~ "vivian davis",
                           lname == "minnick" & fname == "walter" ~ "walt",
                           lname == "allard" & fname == "a wayne" ~ "wayne",
                           lname == "ball" & fname == "gordon" ~ "william gordon",
                           lname == "lujan" & fname == "ben" ~ "ben ray",
                           lname == "slattery" & fname == "james" ~ "jim",
                           lname == "hoeven" & fname == "john & dalrymple" ~ "john",
                           lname == "hegar" & fname == "mary" ~ "mj",
                           lname == "mehta" & fname == "rikin" ~ "rik",
                           lname == "tuberville" & fname == "thomas" ~ "tommy",
                           TRUE ~ fname),
         lname = case_when(lname == "damato" & fname == "al" ~ "d'amato",
                           lname == "orourke" & fname == "beto" ~ "o'rourke",
                           lname == "hyde smith" & fname == "cindy" ~ "hyde-smith",
                           lname == "rothman serot" & fname == "geri" ~ "rothman-serot",
                           lname == "lloyd jones" & fname == "jean" ~ "lloyd-jones",
                           lname == "odonnell" & fname == "christine" ~ "o'donnell",
                           TRUE ~ lname)) 


#-------------------------------------------------------------------------------


# Merge names with scores -------------------------------------------------

names_scores <- merge(poll_names, 
                      select(scores,c(cycle, lname, fname, recipient.cfscore)), 
                      by = c("fname", "lname", "cycle"), all.x = T) %>% 
  add_count(candidate_name, cycle)

# check missing cf scores
missing_cf_score <- subset(names_scores, is.na(recipient.cfscore) == T)

# no entry for: Mark Clayton, Mike Workman, Jim Rogers, Dan Carter & 2022 candidates not running in previous elections

# merge without cycle
matching_cf_score <- merge(select(missing_cf_score, -recipient.cfscore), 
                           select(scores,c(lname, fname, recipient.cfscore)), 
                       by = c("lname", "fname")) %>% 
  distinct()

# rbind 
names_scores <- rbind(names_scores[!is.na(names_scores$recipient.cfscore),],
                      matching_cf_score) %>% 
  unique()

rm(cf_scores, matching_cf_score, missing_cf_score, poll_names, scores)


# Merge scores with polls -------------------------------------------------

# prepare candidate names in poll data 
polls <- polls %>% 
  mutate(candidate_name_rep = candidate_name_rep %>% 
           tolower() %>% 
           str_replace_all(" van ", " van") %>% 
           str_remove_all("\\s+iii|[,]"),
         candidate_name_rep =  case_when(candidate_name_rep == "pipkin" ~ "e pipkin",
                                     TRUE ~ candidate_name_rep),
         candidate_name_dem = candidate_name_dem %>% 
           tolower() %>% 
           str_replace_all(" van ", " van") %>% 
           str_remove_all("\\s+iii|[,]"))

# Dem. candidates
polls_scores_dem <- merge(polls, 
                          select(names_scores, c(candidate_name, cycle, 
                                                 recipient.cfscore)), 
                          by.x = c("candidate_name_dem", "cycle"),
                          by.y = c("candidate_name", "cycle"), all.x = T) %>% 
  rename(cf_score_dem = recipient.cfscore)

# Rep. candidates
polls_scores <- merge(polls_scores_dem, 
                      select(names_scores, c(candidate_name, cycle, 
                                             recipient.cfscore)), 
                      by.x = c("candidate_name_rep", "cycle"),
                      by.y = c("candidate_name", "cycle"), all.x = T) %>% 
  rename(cf_score_rep = recipient.cfscore) %>% 
  mutate(senator = senator %>% 
           tolower() %>% 
           str_replace_all(" van ", " van") %>% 
           str_remove_all("\\s+iii|[,]"),
         inc = case_when(candidate_name_rep == senator ~ "rep_inc",
                         candidate_name_dem == senator ~"dem_inc",
                         candidate_name_rep != senator & candidate_name_dem != senator ~ "open"))

# save data
saveRDS(polls_scores, "data/polls/polls1990_2022_fte_scores.RDS")

