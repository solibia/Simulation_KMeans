/**
* Name: mstp1PAZIMNASolibia
* Author: basile
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model mstp1PAZIMNASolibia

global {
	/** Insert the global definitions, variables and actions here */
	int N <- 30 parameter: "N value";
	int K <- 5 parameter: "K value";
	int size_centre;
	int size_point <- 2;
	int nb_K_invariant <- 0;
	list couleurs;
	init {
		//Creation de couleur

		loop i from: 0 to: K-1 {
			//rgb color <- rgb(0,200+rnd(55),0);
			create Centre number: 1{
				size_g <- size_point;
				couleur <- rnd_color(255); // rgb([0, 200 + (i*5), 0]); //rgb(255,5*i+1,5*i+1);
			}
		}
		
		create PointNormal number: N{
			size_g <- size_point;
		}
	}
}

	
species PointGeneral {
	point position;
	rgb couleur;
	int size_g; 
}
species PointNormal parent: PointGeneral{
	//size_g <- size_point;
	
	reflex detect_centre {
		let my_centre value: first (list(Centre)sort_by(self distance_to each));
		self.couleur <- my_centre.couleur;
		//write "my_centre";
	}
	
	aspect basic {
		draw circle(size_g) color:couleur;
	}
}
species Centre parent: PointGeneral{
	//set size_g <- size_point;
	
	reflex detect_position {
		let my_group value: (list(PointNormal) where (each.couleur = self.couleur));
		//Calculer la position moyenne
		//write length(my_group);
		if(length(my_group)>1){
			PointNormal new_middle_point <- my_group[0];
			PointNormal current_point <- my_group[0];
			loop i from: 1 to: length(my_group)-1 {
				current_point <- my_group[i];
				int x_calc <- (new_middle_point.location.x+current_point.location.x)/2;
				int y_calc <- (new_middle_point.location.y+current_point.location.y)/2;			
				new_middle_point.location <- point(x_calc,y_calc);
				//new_middle_point.y <- (new_middle_point.y+current_point.y)/2;
			}
			if(self.location=new_middle_point.location){
				nb_K_invariant <- nb_K_invariant + 1;
				write nb_K_invariant;
				if(nb_K_invariant=K){
					//Fin de la simulation stop
					write "Fin de la simulation";
				}
			}else{
				self.position <- new_middle_point.position;
			}
		}
	}
	
	aspect basic {
		draw square(size_g) color:couleur;
	}
}

experiment mstp1PAZIMNASolibia type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		display mstp1PAZIMNASolibia {
			species Centre aspect: basic;
			species PointNormal aspect: basic;
		}
	}
}
