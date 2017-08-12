# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VinculiApi.Repo.insert!(%VinculiApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

cql_insert = """
//Towns
CREATE (edinburgh:Town      {uuid: 'town-1', name:'Edinburgh'}) //Add geoloc
CREATE (kirkcaldy:Town      {uuid: 'town-2', name:'Kirkcaldy'}) //Add geoloc
CREATE (konigsberg:Town     {uuid: 'town-3', name:'Königsberg'}) //Add geoloc
CREATE (wien:Town           {uuid: 'town-4', name:'Wien'}) //Add geoloc
CREATE (cambridge:Town      {uuid: 'town-5', name:'Cambridge'})
CREATE (gdansk:Town         {uuid: 'town-6', name:'Gdansk'})
CREATE (frankfurt:Town      {uuid: 'town-7', name:'Frankfurt'})
CREATE (prosnitz:Town       {uuid: 'town-8', name:'Prossnitz'})
CREATE (freiburg:Town       {uuid: 'town-9', name:'Freiburg'})
CREATE (breslau:Town        {uuid: 'town-10', name:'Breslau'})
CREATE (auschwitz:Town      {uuid: 'town-11', name:'Auschwitz'})
CREATE (epinal:Town         {uuid: 'town-12', name:'Épinal'})
CREATE (paris:Town          {uuid: 'town-13', name:'Paris'})

//Countries
CREATE (scotland:Country        {uuid: 'country-1', name:'Scotland'}) //Add geoloc
CREATE (prussia:Country         {uuid: 'country-2', name:'Prussia'}) //Add geoloc
CREATE (germany:Country         {uuid: 'country-3', name:'Germany'}) //Add geoloc
CREATE (austrian_emp:Country    {uuid: 'country-4', name:'Austrian Empire'}) //Add geoloc
CREATE (austria:Country         {uuid: 'country-5', name:'Austria'})
CREATE (england:Country         {uuid: 'country-6', name:'England'})
CREATE (poland:Country          {uuid: 'country-7', name:'Poland'})
CREATE (france:Country          {uuid: 'country-8', name:'France'})

//Continent
CREATE (europe:Continent {uuid: 'continent-1', name:'Europe'}) //Add geoloc

//Definition of location
CREATE (edinburgh)-[:IS_IN_COUNTRY]->(scotland)
CREATE (kirkcaldy)-[:IS_IN_COUNTRY]->(scotland)
CREATE (konigsberg)-[:IS_IN_COUNTRY]->(prussia)
CREATE (wien)-[:IS_IN_COUNTRY]->(austria)
CREATE (cambridge)-[:IS_IN_COUNTRY]->(england)
CREATE (gdansk)-[:IS_IN_COUNTRY]->(prussia)
CREATE (frankfurt)-[:IS_IN_COUNTRY]->(prussia)
CREATE (prosnitz)-[:IS_IN_COUNTRY]->(austrian_emp)
CREATE (freiburg)-[:IS_IN_COUNTRY]->(germany)
CREATE (breslau)-[:IS_IN_COUNTRY]->(prussia)
CREATE (auschwitz)-[:IS_IN_COUNTRY]->(poland)
CREATE (epinal)-[:IS_IN_COUNTRY]->(france)
CREATE (paris)-[:IS_IN_COUNTRY]->(france)

CREATE (scotland)-[:IS_IN_CONTINENT]->(europe)
CREATE (prussia)-[:IS_IN_CONTINENT]->(europe)
CREATE (germany)-[:IS_IN_CONTINENT]->(europe)
CREATE (austrian_emp)-[:IS_IN_CONTINENT]->(europe)
CREATE (austria)-[:IS_IN_CONTINENT]->(europe)
CREATE (england)-[:IS_IN_CONTINENT]->(europe)
CREATE (poland)-[:IS_IN_CONTINENT]->(europe)
CREATE (france)-[:IS_IN_CONTINENT]->(europe)

//Languages
CREATE (german:Language     {uuid:'language-1', name:'German'})
CREATE (english:Language    {uuid:'language-2', name:'English'})
CREATE (french:Language     {uuid:'language-3', name:'French'})

//Degrees
CREATE (phd:Degree {uuid:'degree-1', name:'PhD'})

//Years
CREATE (y1711:Year {uuid:'year-1', value:1711})
CREATE (y1723:Year {uuid:'year-2', value:1723})
CREATE (y1724:Year {uuid:'year-3', value:1724})
CREATE (y1740:Year {uuid:'year-4', value:1740})
CREATE (y1748:Year {uuid:'year-5', value:1748})
CREATE (y1751:Year {uuid:'year-6', value:1751})
CREATE (y1755:Year {uuid:'year-7', value:1755})
CREATE (y1757:Year {uuid:'year-8', value:1757})
CREATE (y1759:Year {uuid:'year-9', value:1759})
CREATE (y1776:Year {uuid:'year-10', value:1776})
CREATE (y1781:Year {uuid:'year-11', value:1781})
CREATE (y1786:Year {uuid:'year-12', value:1786})
CREATE (y1788:Year {uuid:'year-13', value:1788})
CREATE (y1790:Year {uuid:'year-14', value:1790})
CREATE (y1804:Year {uuid:'year-15', value:1804})
CREATE (y1813:Year {uuid:'year-16', value:1813})
CREATE (y1819:Year {uuid:'year-17', value:1819})
CREATE (y1847:Year {uuid:'year-18', value:1847})
CREATE (y1858:Year {uuid:'year-19', value:1858})
CREATE (y1859:Year {uuid:'year-20', value:1859})
CREATE (y1860:Year {uuid:'year-21', value:1860})
CREATE (y1872:Year {uuid:'year-22', value:1872})
CREATE (y1889:Year {uuid:'year-23', value:1889})
CREATE (y1891:Year {uuid:'year-24', value:1891})
CREATE (y1893:Year {uuid:'year-25', value:1893})
CREATE (y1895:Year {uuid:'year-26', value:1895})
CREATE (y1900:Year {uuid:'year-27', value:1900})
CREATE (y1901:Year {uuid:'year-28', value:1901})
CREATE (y1902:Year {uuid:'year-29', value:1902})
CREATE (y1912:Year {uuid:'year-30', value:1912})
CREATE (y1913:Year {uuid:'year-31', value:1913})
CREATE (y1916:Year {uuid:'year-32', value:1916})
CREATE (y1917:Year {uuid:'year-33', value:1917})
CREATE (y1921:Year {uuid:'year-34', value:1921})
CREATE (y1922:Year {uuid:'year-35', value:1922})
CREATE (y1924:Year {uuid:'year-36', value:1924})
CREATE (y1938:Year {uuid:'year-37', value:1938})
CREATE (y1942:Year {uuid:'year-39', value:1942})
CREATE (y1950:Year {uuid:'year-40', value:1950})
CREATE (y1951:Year {uuid:'year-41', value:1951})
CREATE (y1953:Year {uuid:'year-42', value:1953})

//Institution
CREATE (konigs_univ:Institution     {uuid:'institution-1', type:'university', name:'Albertus-Universität Königsberg'})
CREATE (cambridge_univ:Institution  {uuid:'institution-2', type:'university', name:'University of Cambridge'})

//Profession
CREATE (teacher:Profession      {uuid:'profession-1', name:'Teacher'})
CREATE (professor:Profession    {uuid:'profession-2', name:'Professor'})
CREATE (rector:Profession       {uuid:'profession-3', name:'Rector'})

//Domain
CREATE (philo:Domain    {uuid:'domain-1', name:'Philosophy'})
CREATE (anthropo:Domain {uuid:'domain-2', name:'Anthropology'})
CREATE (socio:Domain    {uuid:'domain-3', name:'Sociology'})
CREATE (socials:Domain  {uuid:'domain-4', name:'Social sciences'})

//Schools
CREATE (empiricism:School           {uuid:'school-1', name:'Empiricism'})
CREATE (skepticism:School           {uuid:'school-2', name:'Skepticism'})
CREATE (kantianism:School           {uuid:'school-3', name:'Kantianism'})
CREATE (philo_enlightment:School    {uuid:'school-4', name:'Enlightment Philosophy'})
CREATE (scott_enlightment:School    {uuid:'school-5', name:'Scottish Enlightenment'})
CREATE (morality:School             {uuid:'school-6', name:'Morality'})
CREATE (cl_eco:School               {uuid:'school-7', name:'Classical economics'})
CREATE (analytic_philo:School       {uuid:'school-8', name:'Analytic philosophy'})
CREATE (post_kant:School            {uuid:'school-9', name:'Post-Kantian philosophy'})
CREATE (pheno:School                {uuid:'school-10', name:'Phenomenology'})

//David Hume
CREATE (david_hume:Person   {uuid:'person-1', lastName:'HUME', firstName:'David', internalLink:'http://arsmagica.fr/polyphonies/hume-david-1711-1776', externalLink:'https://en.wikipedia.org/wiki/David_Hume'})
CREATE (thn:Publication     {uuid:'publication-1', type:'book', title:'A Treatise of Human Nature'})
CREATE (echu:Publication    {uuid:'publication-2', type:'book', title:'An Enquiry Concerning Human Understanding'})
CREATE (ecpm:Publication    {uuid:'publication-3', type:'book', title:'An Enquiry Concerning the Principles of Morals'})
CREATE (nhr:Publication     {uuid:'publication-4', type:'book', title:'The Natural History of Religion'})

//Adam Smith
CREATE (adam_smith:Person   {uuid:'person-2', lastName:'SMITH', firstName:'Adam'})
CREATE (tms:Publication     {uuid: 'publication-5', type:'book', title:'The Theory of Moral Sentiments'})
CREATE (won:Publication     {uuid: 'publication-6', type:'book', title:'An Inquiry into the Nature and Causes of the Wealth of Nations'})

//Kant
CREATE (kant:Person         {uuid:'person-3', lastName:'KANT', firstName:'Immanuel'})
CREATE (krv:Publication     {uuid:'publication-7', title:'Kritik der Reinen Vernunft'})
CREATE (cpr:Translation     {uuid:'translation-1', title:'Critique of Pure Reason'})
CREATE (kpv:Publication     {uuid:'publication-8', title:'Kritik der Praktischen Vernunft'})
CREATE (crpr:Translation    {uuid:'translation-2', title:'Critique of Practical Reason'})
CREATE (ku:Publication      {uuid:'publication-9', title:'Kritik der Urteilskraft'})
CREATE (cj:Translation      {uuid:'translation-3', title:'Critique Of Judgment'})

//Schopenhauer
CREATE (schopenhauer:Person         {uuid:'person-4', lastName:'SCHOPENHAUER', firstName:'Arthur'})
CREATE (zur_grunden:Publication     {uuid:'publication-10', title:'Über die vierfache Wurzel des Satzes vom zureichenden Grunde'})
CREATE (fourfold_root:Translation   {uuid:'translation-4', title:'On the Fourfold Root of the Principle of Sufficient Reason'})
CREATE (welt_wille:Publication      {uuid:'publication-11', title:'Die Welt als Wille und Vorstellung'})
CREATE (worl_will:Translation       {uuid:'translation-5', title:'The World as Will and Representation'})

//Wittgenstein
CREATE (wittgenstein:Person         {uuid:'person-5', lastName:'WITTGENSTEIN', firstName:'Ludwig'})
CREATE (abhandlung:Publication      {uuid:'publication-12', title:'Logisch-Philosophische Abhandlung'})
CREATE (tractatus:Translation       {uuid:'translation-6', title:'Tractatus logico-philosophicus'})
CREATE (untersuchungen:Publication  {uuid:'publication-13', title:'Philosophische Untersuchungen'})
CREATE (investigations:Translation  {uuid:'translation-7', title:'Philosophical Investigations'})

//Husserl
CREATE (husserl:Person                  {uuid:'person-6', lastName:'HUSSERL', firstName:'Edmund'})
CREATE (log_untersuch_1:Publication     {uuid:'publication-14', title:'Logische Untersuchungen: Erster Teil'})
CREATE (logical_invest_1:Translation    {uuid:'translation-8', title:'Logical Investigations, Vol 1'})
CREATE (log_untersuch_2:Publication     {uuid:'publication-15', title:'Logische Untersuchungen: Zweiter Teil'})
CREATE (logical_invest_2:Translation    {uuid:'translation-9', title:'Logical Investigations, Vol 2'})
CREATE (pheno_philo:Publication         {uuid:'publication-16', title:'Ideen zu einer reinen Phänomenologie und phänomenologischen Philosophie'})
CREATE (intro_pheno:Translation         {uuid:'translation-10', title:'Ideas: General Introduction to Pure Phenomenology'})

//Stein
CREATE (stein:Person                {uuid:'person-7', lastName:'STEIN', firstName:'Edith', aka:'St. Teresa Benedicta of the Cross'})
CREATE (prob_einfuhl:Publication    {uuid:'publication-17', title:'Zum Problem der Einfühlung'})
CREATE (empathy_prob:Translation    {uuid:'translation-11', title:'On the Problem of Empathy'})

//Durkheim
CREATE (durkheim:Person                 {uuid:'person-8', lastName:'DURKHEIM', firstName:'Emile'})
CREATE (division_travail:Publication    {uuid:'publication-18', title:'De la division du travail social'})
CREATE (division_labour:Translation     {uuid:'translation-12', title:'The Division of Labour in Society'})
CREATE (formes_vie_relig:Publication    {uuid:'publication-19', title:'Les formes élémentaires de la vie religieuse'})
CREATE (forms_relig_life:Translation    {uuid:'translation-13', title:'The Elementary Forms of Religious Life'})
CREATE (methode_socio:Publication       {uuid:'publication-20', title:'Les Règles de la Méthode Sociologique'})
CREATE (rules_socio:Translation         {uuid:'translation-14', title:'The Rules of Sociological Method'})

//Mauss
CREATE (mauss:Person                {uuid:'person-9', lastName:'MAUSS', firstName:'Marcel'})
CREATE (formes_classif:Publication  {uuid:'publication-21', title:'De quelques formes primitives de classification'})
CREATE (theorie_magie:Publication   {uuid:'publication-22', title:'Esquisse d\\'une théorie générale de la magie'})
CREATE (essai_don:Publication       {uuid:'publication-23', title:'Essai sur le don,'})
CREATE (the_gift:Translation        {uuid:'translation-15', title:'The Gift'})

//Dates of birth/death
CREATE (david_hume)-[:WHERE_BORN]->(edinburgh),
       (david_hume)-[:WHEN_BORN]->(y1711),
       (david_hume)-[:WHERE_DIED]->(edinburgh),
       (david_hume)-[:WHEN_DIED]->(y1776),
       (adam_smith)-[:WHERE_BORN]->(edinburgh),
       (adam_smith)-[:WHEN_BORN]->(y1723),
       (adam_smith)-[:WHERE_DIED]->(edinburgh),
       (adam_smith)-[:WHEN_DIED]->(y1790),
       (kant)-[:WHERE_BORN]->(konigsberg),
       (kant)-[:WHEN_BORN]->(y1724),
       (kant)-[:WHERE_DIED]->(konigsberg),
       (kant)-[:WHEN_DIED]->(y1804),
       (wittgenstein)-[:WHERE_BORN]->(wien),
       (wittgenstein)-[:WHEN_BORN]->(y1889),
       (wittgenstein)-[:WHERE_DIED]->(cambridge),
       (wittgenstein)-[:WHEN_DIED]->(y1951),
       (schopenhauer)-[:WHERE_BORN]->(gdansk),
       (schopenhauer)-[:WHEN_BORN]->(y1788),
       (schopenhauer)-[:WHERE_DIED]->(frankfurt),
       (schopenhauer)-[:WHEN_DIED]->(y1860),
       (husserl)-[:WHERE_BORN]->(prosnitz),
       (husserl)-[:WHEN_BORN]->(y1859),
       (husserl)-[:WHERE_DIED]->(freiburg),
       (husserl)-[:WHEN_DIED]->(y1938),
       (stein)-[:WHERE_BORN]->(breslau),
       (stein)-[:WHEN_BORN]->(y1891),
       (stein)-[:WHERE_DIED]->(auschwitz),
       (stein)-[:WHEN_DIED]->(y1942),
       (durkheim)-[:WHERE_BORN]->(epinal),
       (durkheim)-[:WHEN_BORN]->(y1858),
       (durkheim)-[:WHERE_DIED]->(paris),
       (durkheim)-[:WHEN_DIED]->(y1917),
       (mauss)-[:WHERE_BORN]->(epinal),
       (mauss)-[:WHEN_BORN]->(y1872),
       (mauss)-[:WHERE_DIED]->(paris),
       (mauss)-[:WHEN_DIED]->(y1950)

//David Hume writings
CREATE (david_hume)-[:WROTE]->(thn),
       (thn)-[:WHEN_WRITTEN]->(y1740),
       (thn)-[:IS_OF_DOMAIN]->(philo),
       (thn)-[:IS_OF_SCHOOL]->(empiricism),
       (thn)-[:HAS_ORIGINAL_LANGUAGE]->(english),
       (david_hume)-[:WROTE]->(echu),
       (echu)-[:WHEN_WRITTEN]->(y1748),
       (echu)-[:IS_OF_DOMAIN]->(philo),
       (echu)-[:IS_OF_SCHOOL]->(empiricism),
       (echu)-[:HAS_ORIGINAL_LANGUAGE]->(english),
       (david_hume)-[:WROTE]->(ecpm),
       (ecpm)-[:WHEN_WRITTEN]->(y1751),
       (ecpm)-[:IS_OF_DOMAIN]->(philo),
       (ecpm)-[:IS_OF_SCHOOL]->(empiricism),
       (ecpm)-[:HAS_ORIGINAL_LANGUAGE]->(english),
       (david_hume)-[:WROTE]->(nhr),
       (nhr)-[:WHEN_WRITTEN]->(y1757),
       (nhr)-[:IS_OF_DOMAIN]->(philo),
       (nhr)-[:IS_OF_SCHOOL]->(empiricism),
       (nhr)-[:HAS_ORIGINAL_LANGUAGE]->(english)

//Adam Smith writings
CREATE (adam_smith)-[:WROTE]->(tms),
       (tms)-[:WHEN_WRITTEN]->(y1759),
       (tms)-[:IS_OF_DOMAIN]->(philo),
       (tms)-[:IS_OF_SCHOOL]->(morality),
       (tms)-[:HAS_ORIGINAL_LANGUAGE]->(english),
       (adam_smith)-[:WROTE]->(won),
       (won)-[:WHEN_WRITTEN]->(y1776),
       (won)-[:IS_OF_DOMAIN]->(philo),
       (won)-[:IS_OF_SCHOOL]->(cl_eco),
       (won)-[:HAS_ORIGINAL_LANGUAGE]->(english)

//Kant scholars
CREATE (kant)-[:HAS_DEGREE]->(phd),
       (phd)-[:DEGREE_FROM]->(konigs_univ),
       (kant)-[:HAS_PROFESSION]->(teacher),
       (teacher)-[:EMPLOYED_BY]->(konigs_univ),
       (teacher)-[:EMPLOYED_FROM]->(y1755),
       (teacher)-[:EMPLOYED_TO]->(y1786),
       (kant)-[:HAS_PROFESSION]->(rector),
       (rector)-[:EMPLOYED_BY]->(konigs_univ),
       (rector)-[:EMPLOYED_FROM]->(y1786),
       (rector)-[:EMPLOYED_TO]->(y1788)
// CREATE (kant)-[:DEGREE_FROM {degree:'PhD'}]->(konigs_univ),
//       (kant)-[:TAUGHT_IN {from:1755, to:1786}]->(konigs_univ),
//       (kant)-[:HEAD {job:'rector'}]->(konigs_univ)

//Kant writings
CREATE (kant)-[:WROTE]->(krv),
       (krv)-[:WHEN_WRITTEN]->(y1781),
       (krv)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (krv)-[:TRANSLATED]->(cpr),
       (krv)-[:IS_OF_DOMAIN]->(philo),
       (krv)-[:IS_OF_SCHOOL]->(kantianism),
       (cpr)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (kant)-[:WROTE]->(kpv),
       (kpv)-[:WHEN_WRITTEN]->(y1788),
       (kpv)-[:IS_OF_DOMAIN]->(philo),
       (kpv)-[:IS_OF_SCHOOL]->(kantianism),
       (kpv)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (kpv)-[:TRANSLATED]->(crpr),
       (crpr)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (kant)-[:WROTE]->(ku),
       (ku)-[:WHEN_WRITTEN]->(y1790),
       (ku)-[:IS_OF_DOMAIN]->(philo),
       (ku)-[:IS_OF_SCHOOL]->(kantianism),
       (ku)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (ku)-[:TRANSLATED]->(cj),
       (cj)-[:TRANSLATED_IN_LANGUAGE]->(english)

//Schopenhauer writings
CREATE (schopenhauer)-[:WROTE]->(zur_grunden),
       (zur_grunden)-[:WHEN_WRITTEN]->(y1813),
       (zur_grunden)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (zur_grunden)-[:TRANSLATED]->(fourfold_root),
       (zur_grunden)-[:IS_OF_DOMAIN]->(philo),
       (zur_grunden)-[:IS_OF_SCHOOL]->(post_kant),
       (zur_grunden)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (schopenhauer)-[:WROTE]->(welt_wille),
       (welt_wille)-[:WHEN_WRITTEN]->(y1819),
       (welt_wille)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (welt_wille)-[:TRANSLATED]->(worl_will),
       (welt_wille)-[:IS_OF_DOMAIN]->(philo),
       (welt_wille)-[:IS_OF_SCHOOL]->(post_kant),
       (welt_wille)-[:TRANSLATED_IN_LANGUAGE]->(english)

//Wittgenstein scholars
//CREATE (wittgenstein)-[:HAS_DEGREE]->(phd),
 //      (phd)-[:DEGREE_FROM]->(cambridge_univ),
CREATE (wittgenstein)-[:HAS_PROFESSION]->(professor),
       (professor)-[:EMPLOYED_BY]->(cambridge_univ)

//Wittgenstein writings
CREATE (wittgenstein)-[:WROTE]->(abhandlung),
       (abhandlung)-[:WHEN_WRITTEN]->(y1921),
       (abhandlung)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (abhandlung)-[:TRANSLATED]->(tractatus),
       (abhandlung)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (abhandlung)-[:WHEN_TRANSLATED]->(y1922),
       (abhandlung)-[:IS_OF_DOMAIN]->(philo),
       (abhandlung)-[:IS_OF_SCHOOL]->(analytic_philo),
       (wittgenstein)-[:WROTE]->(untersuchungen),
       (untersuchungen)-[:WHEN_WRITTEN]->(y1953),
       (untersuchungen)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (untersuchungen)-[:TRANSLATED]->(investigations),
       (untersuchungen)-[:IS_OF_DOMAIN]->(philo),
       (untersuchungen)-[:IS_OF_SCHOOL]->(analytic_philo)

//Husserl writings
CREATE (husserl)-[:WROTE]->(log_untersuch_1),
       (log_untersuch_1)-[:WHEN_WRITTEN]->(y1900),
       (log_untersuch_1)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (log_untersuch_1)-[:TRANSLATED]->(logical_invest_1),
       (log_untersuch_1)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (log_untersuch_1)-[:IS_OF_DOMAIN]->(philo),
       (log_untersuch_1)-[:IS_OF_SCHOOL]->(pheno),
       (husserl)-[:WROTE]->(log_untersuch_2),
       (log_untersuch_2)-[:WHEN_WRITTEN]->(y1901),
       (log_untersuch_2)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (log_untersuch_2)-[:TRANSLATED]->(logical_invest_2),
       (log_untersuch_2)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (log_untersuch_2)-[:IS_OF_DOMAIN]->(philo),
       (log_untersuch_2)-[:IS_OF_SCHOOL]->(pheno),
       (husserl)-[:WROTE]->(pheno_philo),
       (pheno_philo)-[:WHEN_WRITTEN]->(y1913),
       (pheno_philo)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (pheno_philo)-[:TRANSLATED]->(intro_pheno),
       (pheno_philo)-[:IS_OF_DOMAIN]->(philo),
       (pheno_philo)-[:IS_OF_SCHOOL]->(pheno)

CREATE (stein)-[:WROTE]->(prob_einfuhl),
       (prob_einfuhl)-[:WHEN_WRITTEN]->(y1916),
       (prob_einfuhl)-[:HAS_ORIGINAL_LANGUAGE]->(german),
       (prob_einfuhl)-[:TRANSLATED]->(empathy_prob),
       (prob_einfuhl)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (prob_einfuhl)-[:IS_OF_DOMAIN]->(philo),
       (prob_einfuhl)-[:IS_OF_SCHOOL]->(pheno)

CREATE (durkheim)-[:WROTE]->(division_travail),
       (division_travail)-[:WHEN_WRITTEN]->(y1893),
       (division_travail)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (division_travail)-[:TRANSLATED]->(division_labour),
       (division_travail)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (division_travail)-[:IS_OF_DOMAIN]->(anthropo),
       (division_travail)-[:IS_OF_DOMAIN]->(socio),
       (durkheim)-[:WROTE]->(formes_vie_relig),
       (formes_vie_relig)-[:WHEN_WRITTEN]->(y1912),
       (formes_vie_relig)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (formes_vie_relig)-[:TRANSLATED]->(forms_relig_life),
       (formes_vie_relig)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (formes_vie_relig)-[:IS_OF_DOMAIN]->(anthropo),
       (formes_vie_relig)-[:IS_OF_DOMAIN]->(socio),
       (durkheim)-[:WROTE]->(methode_socio),
       (methode_socio)-[:WHEN_WRITTEN]->(y1895),
       (methode_socio)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (methode_socio)-[:TRANSLATED]->(rules_socio),
       (methode_socio)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (methode_socio)-[:IS_OF_DOMAIN]->(anthropo),
       (methode_socio)-[:IS_OF_DOMAIN]->(socio),
       (durkheim)-[:CO_WROTE]->(formes_classif)

CREATE (mauss)-[:WROTE]->(formes_classif),
       (formes_classif)-[:WHEN_WRITTEN]->(y1902),
       (formes_classif)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (formes_classif)-[:IS_OF_DOMAIN]->(anthropo),
       (mauss)-[:WROTE]->(theorie_magie),
       (theorie_magie)-[:WHEN_WRITTEN]->(y1902),
       (theorie_magie)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (theorie_magie)-[:IS_OF_DOMAIN]->(anthropo),
       (mauss)-[:WROTE]->(essai_don),
       (essai_don)-[:WHEN_WRITTEN]->(y1902),
       (essai_don)-[:HAS_ORIGINAL_LANGUAGE]->(french),
       (essai_don)-[:TRANSLATED]->(the_gift),
       (essai_don)-[:TRANSLATED_IN_LANGUAGE]->(english),
       (essai_don)-[:IS_OF_DOMAIN]->(anthropo)

//Influences
CREATE (david_hume)-[:INFLUENCED {strength: 5}]->(adam_smith),
       (david_hume)-[:INFLUENCED {strength: 3}]->(kant),
       (david_hume)-[:INFLUENCED {strength: 2}]->(husserl),
       (david_hume)-[:INFLUENCED {strength: 1}]->(stein),
       (david_hume)-[:INFLUENCED {strength: 2}]->(durkheim),
       (david_hume)-[:INFLUENCED {strength: 2}]->(mauss),
       (kant)-[:INFLUENCED {strength: 4}]->(schopenhauer),
       (kant)-[:INFLUENCED {strength: 2}]->(husserl),
       (kant)-[:INFLUENCED {strength: 2}]->(durkheim),
       (schopenhauer)-[:INFLUENCED {strength: 3}]->(wittgenstein),
       (husserl)-[:INFLUENCED {strength: 3}]->(stein),
       (stein)-[:INFLUENCED {strength: 5}]->(husserl),
       (durkheim)-[:INFLUENCED {strength: 4}]->(mauss)
;
"""
neo4j_conn = Bolt.Sips.begin(Bolt.Sips.conn)
Bolt.Sips.query!(neo4j_conn, cql_insert)
Bolt.Sips.commit(neo4j_conn)