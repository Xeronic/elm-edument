module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, placeholder, src, href)
import Html.Events exposing (onInput, onClick)


main : Program Never Model Msg
main =
    beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    { recipes : List Recipe
    , filteredRecipes : List Recipe
    , page : Page
    }


type alias Recipe =
    { description : String
    , id : String
    , ingredients : List (List String)
    , lead : String
    , level : String
    , name : String
    , procedure : List String
    , rating : Int
    , servings : Int
    , time : String
    , tips : String
    }


init : Model
init =
    { recipes = recipes
    , filteredRecipes = recipes
    , page = RecipesPage
    }


type Msg
    = NoOp
    | FilterRecipes String
    | GoToRecipe Recipe


type Page
    = RecipesPage
    | RecipePage Recipe


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        FilterRecipes searchTerm ->
            { model
                | filteredRecipes =
                    List.filter (\recipe -> String.contains (String.toLower searchTerm) (String.toLower recipe.name)) model.recipes
            }

        GoToRecipe recipe ->
            { model | page = RecipePage recipe }


view : Model -> Html Msg
view model =
    case model.page of
        RecipePage recipe ->
            viewRecipePage recipe

        RecipesPage ->
            viewRecipesPage model


viewRecipePage recipe =
    div [] [ text (toString recipe) ]


viewRecipesPage : Model -> Html Msg
viewRecipesPage model =
    div []
        [ div [ id "recipe-search", onInput FilterRecipes ]
            [ input [ placeholder "search for recipes" ] []
            ]
        , viewRecipeList model.filteredRecipes
        ]


viewRecipeList : List Recipe -> Html Msg
viewRecipeList list =
    div [ id "recipe-list" ] (List.map viewRecipeCard list)


viewRecipeCard : Recipe -> Html Msg
viewRecipeCard recipe =
    div [ class "recipe recipe-card" ]
        [ a [ onClick (GoToRecipe recipe) ]
            [ img [ src ("images/" ++ recipe.id ++ ".jpg") ] []
            , div [ class "description" ]
                [ h2 [] [ text recipe.name ]
                , p [ class "lead" ] [ text recipe.lead ]
                , viewRating recipe.rating
                ]
            ]
        ]


viewRating : Int -> Html Msg
viewRating rating =
    let
        stars =
            List.map
                (\n ->
                    if n < rating then
                        span [ class "glyphicon glyphicon-star" ] []
                    else
                        span [ class "glyphicon glyphicon-star-empty" ] []
                )
                [ 1, 2, 3, 4, 5 ]
    in
        p [ class "recipe-rating" ] stars



-- Extern data source


recipes : List Recipe
recipes =
    [ { id = "chicken-tikka-masala"
      , name = "Chicken Tikka Masala"
      , rating = 4
      , servings = 4
      , time = "1 hour"
      , level = "Medium"
      , lead = "Chicken tikka masala is a dish based on chunks of Indian-style roast chicken (Chicken Tikka) cooked in a tomato/curry sauce, originating in Britain but intentionally recalling Indian dishes."
      , description = "There is no standard recipe for chicken tikka masala; a survey found that of 48 different recipes the only common ingredient was chicken. The sauce usually includes tomato and either cream or coconut cream and various spices."
      , ingredients =
            [ [ "700", "g", "cooked Chicken Tikka" ]
            , [ "2", "tbsp", "mustard seed oil" ]
            , [ "4", "large cloves", "of garlic, finely chopped" ]
            , [ "200", "g", "onions, finely chopped (optional)" ]
            , [ "1", "can", "of plum tomatoes, chopped" ]
            , [ "1", "", "chopped fresh green chilli" ]
            , [ "2", "tbsp", "chopped fresh cilantro (coriander leaves)" ]
            , [ "0.5", "dl", "single cream" ]
            , [ "1", "tbsp", "malt vinegar" ]
            , [ "2", "tbsp", "curry paste" ]
            , [ "2", "tbsp", "tandoori masala paste" ]
            , [ "1", "tbsp", "tomato paste" ]
            , [ "1", "tbsp", "garam masala" ]
            ]
      , procedure =
            [ "Heat the oil in a wok (if available, otherwise a large frying pan)."
            , "Add the garlic and onions (if using) and stir-fry until browned."
            , "Add the curry pastes and mix well, adding a little water or yogurt."
            , "Add the cooked chicken tikka and stir-fry for two minutes to heat through."
            , "Add the tomatoes, vinegar, tomato paste and chillies and simmer for five minutes. Add more water if required."
            , "Add the cream, garam masala and chopped cilantro and simmer for a few minutes."
            , "Garnish with fresh coriander and serve with Naan bread, rice coloured yellow with turmeric, onion bahjis and/or a glass of white wine."
            ]
      , tips = "* Mustard seed oil is considered unfit for human consumption in many parts of the world and is therefore not always available. A poor alternative can be made by crackling 0.5 tsp of mustard seeds in approximately 2 tbsp of very hot vegetable or olive oil. Allow to cool then use in place of mustard seed oil.\n* Powdered or dried ingredients can be substituted for fresh ones, but at the expense of taste."
      }
    , { id = "french-toast"
      , name = "French Toast"
      , rating = 3
      , servings = 1
      , time = "10 minutes"
      , level = "Easy"
      , lead = "French toast is a common breakfast item made by frying a piece of bread soaked in an egg batter."
      , description = "French toast was developed as a way to use day-old stale bread. When lacking stale bread, toasting your bread lightly will help it absorb more of the egg and milk batter.\n\nFrench toast is usually served with toppings similar to those used for pancakes, waffles, and toast. Suggested toppings are=\n\n* real maple syrup, table syrup\n\n* jam, jelly, fruit syrup\n\n* whipped cream\n\n* powdered sugar\n\n* nuts\n\n* honey (as served in China)\n\n* bacon\n\n* raspberries and/or strawberries and/or blueberries\n\nIt can also be served as part of a fried breakfast with savory foods like sausages (or vegetarian equivalent), tomato (or ketchup), baked beans, fried mushrooms etc.\n\nThis recipe is easily scalable. The simplest thing to do is to memorize the recipe for two slices (1 serving), and then multiply to make more. You can coat slightly more than one serving with the wet parts of the recipe (2.25 - 2.5 normal-sized slices)."
      , ingredients =
            [ [ "1", "", "egg" ]
            , [ "0.5", "dl", "milk" ]
            , [ "2", "slices", "of bread, preferably 2.5 cm slices of French bread" ]
            , [ "butter (best), margarine, or cooking oil" ]
            ]
      , procedure =
            [ "In a bowl, mix eggs and milk, and optional ingredients."
            , "Heat up a frying pan, skillet or griddle to medium-low heat."
            , "Grease the pan with butter, margarine, or cooking spray."
            , "Soak a slice of bread in the egg-milk mixture and place on pan; repeat until pan is full or desired amount is placed."
            , "Brown both sides bread."
            , "Serve on plates, usually two slices per person, with toppings as desired."
            ]
      , tips = "The goal is to get both sides of the French toast nicely browned, while making sure the center is cooked. Using excessive heat could scorch the outside of the toast while leaving the inside undercooked.\n\nAlso, if you are not producing many multiples of the recipe, it is easier to evenly soak each slice of bread in the egg and milk mixture if you make it in small batches, with one egg and 0.5 dl of milk and two slices at a time in one bowl. Then, soak the two slices until almost all of the mixture has been absorbed. If the bowl is small, place the two slices on top of each other, and keep switching and flipping them, so that all four sides will absorb the mixture.\n\nThe cooking process is too short to use most raw spices, but some fresh herbs might be very tasty.\n\nIf using sandwich bread, a plastic sandwich container may be used for the egg-milk mixture. This allows maximum use of the mixture, as the container is a good size and shape."
      }
    , { id = "hamburger"
      , name = "Hamburger"
      , rating = 5
      , servings = 4
      , time = "20 minutes"
      , level = "Easy"
      , lead = "A hamburger is a variant on a sandwich involving a patty of ground meat, usually beef (known in the United Kingdom as a beefburger), or a vegetarian patty."
      , description = "A slice of cheese on the patty makes it a cheeseburger, a common variation in the United States."
      , ingredients =
            [ [ "500", "g", "minced (ground) beef" ]
            , [ "Herbs and spices (optional - see suggestions)" ]
            , [ "Cheese (optional - see suggestions)" ]
            , [ "Salad (lettuce, spinach, alfalfa sprouts, tomato, onion etc. - optional)" ]
            , [ "6", "", "hamburger buns" ]
            ]
      , procedure =
            [ "Remove the ground beef from the package and shape by hand into burgers. You should get between 4-6 burgers from 500 g of beef."
            , "If adding optional ingredients, either season the outside or mix into the beef before forming the patties. Overworking the beef will result in mushy meat that won't stick together, so only mix the minimum necessary and do so by hand."
            , "The burgers can be fried or grilled for about 4-5 mins on each side for burgers which aren't too thick."
            , "Let the burger rest for several minutes before serving to let the juices cool down and not burst out at first bite."
            , "Ensure your burgers are fully cooked through before serving. If your burgers are quite thick or if you are unsure, you can cut one open to ensure the insides are browned. If the insides are red, there is a chance that the meat is not fully cooked. Alternately, you can insert a meat thermometer into the center of the burger, if the temperature reads less than 70 °C, your burger is undercooked."
            , "Serve each burger on a bun (sesame seed usually), optionally with relish, sliced pickles, ketchup, mayonnaise, mustard, ranch dressing, cheese, lettuce, tomatoes and/or onions."
            ]
      , tips = "Some suggestions of what to add to the meat include= garlic, onion flakes or a small onion, soy sauce, worcestershire sauce, mustard, olive oil, cheese, butter and/or 2 tsp of your favorite hot sauce for some kick. The amounts of herbs and/or spices are up to your local taste and meat quality. Depending on the quality of your local beef, for example, you may wish to add some beef stock to improve the flavour. If you add any liquids, mix the ground beef well then squeeze out the extra juice when forming patties.\n\n* Make sure to let the meat get to room temperature before putting on the grill or in the pan. This will help the burgers cook evenly and fully.\n* You can use almost any type of minced (ground) meat to make hamburgers, including pork, chicken, turkey, lamb, bison, venison, ostrich, or even a meat substitute such as Quorn. Some variations of hamburgers call for mixing different types of meat (e.g. ground beef and ground pork).\n* Do not add salt until right before you put the patty to cook.\n* Mixing ingredients in with the meat is purely optional. You can make a delicious burger by simply shaping patties and seasoning with kosher salt, ground pepper, and if you wish, some garlic powder and/or cayenne.\n* If your burgers fall apart, adding an egg yolk will help keep it together. Buying lean ground beef will also help, although if the meat is too lean the burger may be excessively dry. Not mixing the ground meat in the first place will also ensure the patty's integrity.\n* Try adding a pat of butter in the center of each burger for an excellent hamburger.\n* You may wish to experiment with including cheese in the centre of your burger before cooking.\n* Spices which can work well in hamburgers include black pepper, chili (either fresh or powder), Worcestershire Sauce and soy sauce. Experiment to find good combinations.\n* Almost any herb can work, including basil, oregano and parsley.\n* Some other things which are also sometimes added to hamburgers include= diced onions, bread crumbs, crushed saltine crackers.\n* Burgers can also be smoked on a grill. Smoked burgers will appear red and glazed on the outside, but browned on the inside. Smoking a burger before grilling it is an excellent way to seal in the flavorful juices.\n* Adding meat and spices together in a bowl and mixing by hand until the spices are distributed may produce better results. This will also help to stop your burgers from falling apart.\n* Some vegan patties make excellent meat substitutes, especially for Hamburgers, where strong spices make the difference close to indistinguishable."
      }
    , { id = "pumpkin-pie"
      , name = "Pumpkin pie"
      , rating = 4
      , servings = 8
      , time = "60 minutes + cooling"
      , level = "Medium"
      , lead = "Pumpkin pie is a traditional American and Canadian holiday dessert."
      , description = "It consists of a pumpkin-based custard baked in a single pie shell. The pie is traditionally served with whipped cream.\n\nUse the smaller 'Sugar Pumpkin' instead of the big 'Jack O Lantern' pumpkin. The smaller 'Sugar Pumpkin' has a firm and smooth texture while the larger 'Jack O Lantern' pumpkin has more stringy or fibrous texture and more watery for a flesh."
      , ingredients =
            [ [ "5", "dl", "milk, scalded" ]
            , [ "500", "g", "pumpkin, cooked and strained (or plain canned pumpkin)" ]
            , [ "2.5", "dl", "maple syrup" ]
            , [ "30", "g", "sugar" ]
            , [ "1", "tbsp", "flour" ]
            , [ "1.5", "tsp", "salt" ]
            , [ "1", "tbsp", "ginger" ]
            , [ "1", "tbsp", "cinnamon" ]
            , [ "1", "tsp", "nutmeg (optional)" ]
            , [ "2", "", "large eggs, beaten" ]
            , [ "1", "", "unbaked 23 cm pie shell" ]
            ]
      , procedure =
            [ "Preheat oven to 175 °C."
            , "Blend all ingredients, except the pie shell, together."
            , "Pour into the unbaked pie shell."
            , "Bake at 175 °C for 45 minutes."
            , "Let cool and serve."
            ]
      , tips = "* This recipe replaces much of the sugar normally found in a pumpkin pie recipe with maple syrup. Use only real 100 percent maple syrup, not maple-flavored pancake syrup, as their sugar content is different. You can also use brown sugar instead of maple syrup.\n* Prepare the raw pumpkin by skinning and cutting into 2.5 cm cubes. Bake at 175 °C for an hour and then turn off the heat. Leave the pumpkin in the oven for another hour or two, this will reduce the moisture content. The pumpkin may also be steamed but may end up with too much moisture, resulting in a runny pie. A pumpkin 25 cm in diameter will make 4 to 6 pies. The pumpkin may also be baked whole and skinned afterwards.\n* Pumpkin pie has no top crust, which makes most forms of decoration impossible, but for a more aesthetically-pleasing pie, put dollops of real whipped cream on each slice, or add a decorative rim to the side crust with artfully layered dough cut-outs, in the shape of fall leaves, squash or pumpkins.\n* Variant: Chocolate-covered pumpkin pie\n    * After the pie has cooled, melt 50 g of sweetened chocolate (milk or dark) and pour over the top of the pie. Be sure to completely cover the pumpkin. Refrigerate to set the chocolate.\n* Variant: Pumpkin Pasties\n    * Roll pie crust pastry thin and cut into circles approx 10 cm in diameter.\n\nPut a spoonful of the cool pumpkin mixture towards one side of the center of the circle. Fold over the crust into a half-circle and firmly crimp the edges closed. Slice three small slits in the top for venting. Place on a greased cookie sheet. Bake only until crust is a light golden-brown, approx 10 minutes."
      }
    , { id = "rhubarb-pie"
      , name = "Rhubarb pie"
      , rating = 5
      , servings = 8
      , time = "1 hour 45 minutes"
      , level = "Medium"
      , lead = "This pie is fairly sweet, but also quite tangy."
      , description = "It is best served warm with a scoop of vanilla ice cream."
      , ingredients =
            [ [ "300", "g", "flour" ]
            , [ "1", "tsp", "salt" ]
            , [ "1", "tsp", "sugar (optional)" ]
            , [ "250", "g", "butter, cold" ]
            , [ "1", "dl", "cold water" ]
            , [ "1", "kg", "rhubarb stalks" ]
            , [ "3.5", "dl", "sugar" ]
            , [ "0.5", "dl", "cornstarch or tapioca pearls" ]
            , [ "0.5", "tsp", "salt" ]
            ]
      , procedure =
            [ "Clean and trim the rhubarb stalks."
            , "Cut the stalks into 1.25 cm to 2.5 cm sections."
            , "Add sugar, cornstarch or tapioca, and salt."
            , "Stir until rhubarb is evenly coated with dry ingredients."
            , "Whisk flour, salt and sugar together in a deep bowl."
            , "Cut the butter into small pieces and add to the flour mixture."
            , "Using a pastry blender or two butter knives, cut the butter into the flour until the butter is in small pea-sized pieces."
            , "Add cold water; cut the water into the flour-butter mixture with the edge of a rubber spatula until it is evenly moistened and will hold together when pressed."
            , "Form the dough into a ball with your hands, kneading in any loose flour. This should be done as quickly as possible to avoid melting the butter in the dough."
            , "Chill the dough for 10-20 minutes."
            , "Cut the dough evenly in half."
            , "On a lightly floured board, roll each half out until it will cover a 20 cm pie dish, with about 2 cm overhang."
            , "Place pie on lowest rack in oven. Bake for 15 minutes. Reduce oven temperature to 175 °C, and continue baking for 40 to 45 minutes. Serve warm or cold."
            ]
      , tips = "* If cornstarch is used as the thickener, the pie requires a longer cooling time before the filling is gelled.\n* Another variation is to use a whole egg in the mix."
      }
    , { id = "spaghetti-alla-carbonara"
      , name = "Spaghetti alla Carbonara"
      , rating = 4
      , servings = 6
      , time = "60 minutes"
      , level = "Medium"
      , lead = "Spaghetti alla carbonara is an Italian pasta dish based on eggs, pecorino romano, guanciale and black pepper."
      , description = "It was created in the middle of the 20th century.\n\nRecipes vary, though all agree that pecorino romano, eggs, cured fatty pork and black pepper are basic. The pork is fried in fat (olive oil or lard). Then, a mixture of eggs, cheese and olive oil is combined with the hot pasta, thereby cooking the eggs. All of the ingredients are then mixed together. Guanciale is the most traditional bacon for this recipe, but pancetta is a popular substitute. In the US, it is often made with American bacon.\n\nCream is not common in Italian recipes, but is used in the United States, France, the United Kingdom, Australia and Russia (especially in Moscow). Italian Chef Luigi Carnacina used cream in his recipe Other Anglo/Franco variations on carbonara may include peas, broccoli or other vegetables added for colour. Yet another American version includes mushrooms. Many of these preparations have more sauce than the Italian versions.\n\nIn all versions of the recipe, raw eggs are added to the sauce and cook with the heat of the pasta."
      , ingredients =
            [ [ "450", "g", "spaghetti" ]
            , [ "225", "g", "pancetta" ]
            , [ "5", "", "egg yolks" ]
            , [ "2", "dl", "Pecorino Romano cheese" ]
            , [ "2", "dl", "Parmigiano-Reggiano cheese" ]
            , [ "4", "tbsp", "olive oil" ]
            , [ "0.5", "tbsp", "pepper, freshly ground" ]
            , [ "salt" ]
            ]
      , procedure =
            [ "Dice the pancetta into 2.5 cm pieces."
            , "Bring a big pot of water to a boil and add salt to taste when it begins to simmer."
            , "Cook the spaghetti until it is al dente and drain it, reserving 2.5 dl of water."
            , "As spaghetti is cooking, heat the olive oil in a large skillet over a medium-high heat. When the oil is hot, add the pancetta and cook for about 10 minutes over a low flame until the pancetta has rendered most of its fat but is still chewy and barely browned."
            , "In a bowl, slowly whisk about 118 ml of the pasta water into the egg yolks. Add the grated cheese and mix thoroughly with a fork."
            , "Strain the spaghetti and transfer it immediately to the skillet with the pancetta. Toss it and turn off the heat."
            , "Add the egg and cheese mixture to the pasta while stirring in the remaining pasta water to help thin the sauce."
            , "Add the pepper and toss all the ingredients to coat the pasta."
            ]
      , tips = "Like most recipes, the origins of the dish are obscure but there are many legends. As 'carbonara' literally means 'coal miner's wife', some believe that the dish was first made as a hearty meal for Italian coal miners. Others say that it was originally made over charcoal grills, or that it was made with squid ink, giving it the color of coal. It has even been suggested that it was created by, or as a tribute to, the \"charcoalmen\", a secret society prominent in the unification of Italy. Also, the name may be from a Roman restaurant named Carbonara.\n\nThe dish is not present in Ada Boni's 1927 classic La Cucina Romana, and is unrecorded before the Second World War. It was first recorded after the war as a Roman dish, when many Italians were eating eggs and bacon supplied by American troops.\n\nIdeally this dish is served with a red wine (Merlot, Chianti, Montepulciano d’Abruzzo), allowed to decant for several hours, and served at 18 °C."
      }
    , { id = "spaghetti-and-meatballs"
      , name = "Spaghetti and meatballs"
      , rating = 3
      , servings = 8
      , time = "1 hour"
      , level = "Medium"
      , lead = "Most food historians agree that the union of spaghetti with meatballs is an American culinary invention with Italian roots."
      , description = "In the vast majority of cases, Old World-Italian cuisine calls for mixing heavy meat sauces with fettuccine and tagliatelle but not spaghetti."
      , ingredients =
            [ [ "3", "tbsp", "salt" ]
            , [ "5", "l", "water" ]
            , [ "500", "g", "dry spaghetti" ]
            , [ "900", "g", "ground chuck" ]
            , [ "900", "g", "ground pork shoulder" ]
            , [ "350", "g", "seasoned bread crumbs" ]
            , [ "2.5", "dl", "grated Parmesan cheese or Romano cheese" ]
            , [ "2", "dl", "fresh parsley, minced" ]
            , [ "4", "", "eggs" ]
            , [ "1.5", "tbsp", "finely minced garlic" ]
            , [ "0.5", "tsp", "garlic powder" ]
            , [ "0.5", "tsp", "onion powder" ]
            , [ "0.5", "tsp", "black pepper" ]
            , [ "0.5", "tsp", "salt" ]
            , [ "olive oil" ]
            , [ "3", "cloves", "of garlic" ]
            , [ "0.5", "tsp", "crushed red chile pepper flakes" ]
            , [ "4", "cloves", "of garlic, crushed or chopped" ]
            , [ "1", "", "small, finely chopped onion" ]
            , [ "2.5", "dl", "beefstock" ]
            , [ "1", "kg", "crushed tomatoes" ]
            , [ "A handful chopped flat-leaf parsley" ]
            , [ "10", "leaves", "fresh basil, torn or thinly sliced" ]
            ]
      , procedure =
            [ "Fill your largest pot with one and a half gallons of water along with three tablespoons of salt. Place it over high heat on the stove."
            , "Combine ground meat, bread crumbs, grated cheese, minced parsley and lightly beaten eggs (add eggs one at a time while stirring ingredients together). Sprinkle with minced garlic, two tablespoons of olive oil and seasonings. Then mix well until everything is combined."
            , "Form meat mixture into meatballs, using an ice cream scoop or your hands, pressing lightly, just enough so that meat holds together, but not so much that the meat is very compressed or the meatballs will be tough and dry."
            , "In a heavy skillet, heat olive oil over medium low heat. Add whole garlic cloves. Turn the garlic cloves to color them on all sides, then when lightly roasted, press them into the oil; as they brown, remove them."
            , "As soon as the oil is hot, add the meatballs to the skillet, leaving about 4 cm between them so that they can be easily turned. Turn them often using a spatula or large spoon so that they don't stick. Make sure there is enough oil in the pan (about 1 cm). You don't need extra virgin olive oil for this, any good quality Italian olive oil will do."
            , "When the meatballs are browned well on all sides, remove from the pan and drain on paper towels. Then add the next batch to the pan and continue until all are cooked."
            , "Add the pasta to the water now boiling in your pot and cook until al dente. This should take about 12 minutes."
            , "Add pepper flakes, garlic and finely chopped onion in the same oil you used to cook the meatballs. Sauté five to seven minutes, until onion bits are soft. Add beef stock, crushed tomatoes, and herbs. Bring to a simmer and cook for about 10 minutes."
            , "Toss hot, drained pasta with a few ladles of the sauce. Turn meatballs in remaining sauce."
            , "Place pasta on dinner plates. Top with meatballs, sauce and extra grated cheese."
            ]
      , tips = ""
      }
    ]
