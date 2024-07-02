/*********************************************
 * OPL 20.1.0.0 Model
 * Author: MatthieuL
 * Creation Date: Jul. 2, 2022 at 3:25:10 p.m.
 *********************************************/

// Measure execution time

float temp;
execute{
var before = new Date();
temp = before.getTime();
}

// Input parameters 

	int J = ...; 			// Number of categories stored
	int K = ...; 			// Number of warehourses 
	int I = ...; 			// Number of customer orders 
	range i = 1..I;			// Set of online custumer orders // Correspond à l'indice i'
	range j = 1..J;	 		// Set of product categories 	 // Correspond à l'indice j'
	range k = 1..K; 		// Set of warehouses correspond à l'indice k'
	int Nmax = ...; 		// Max categories that can be stored on each warehouse
	int Nmin = ...; 		// Min categories that can be stored on each warehouse
	int O[i][j] = ...; 		// If order Oi includes products in categories Cj, Oi(Cj) = 1 else = 0

//Decision variables
	
	dvar boolean x[j][k]; 	// If category Cj is allocated to warehouse Wk, x[j][k] = 1 else = 0
	dvar boolean y[i][k]; 	// If warehouse Wk fufills order Oi,  y[i][k] = 1 else = 0

//Expression
 
 dexpr float Split  = sum(i in 1..I)sum(k in 1..K)(y[i][k] - 1);
 
//Objectif
	
	minimize sum(i in 1..I, k in 1..K)(y[i][k] - 1);
	
// Constraints

subject to {

	C1: forall (j in 1..J)
		sum(k in 1..K) x[j][k] == 1;
		
	C2: forall (k in 1..K)
		Nmin <= sum(j in 1..J) x[j][k] <= Nmax ;
		
	C2bis: forall (k in 1..K)
		 sum(j in 1..J) x[j][k] <= J-0.0000000000000001;
		
	C3: forall (i in 1..I, k in 1..K, j in 1..J) 
		y[i][k] == x[j][k]*O[i][j];

}

execute Display {
	write('_____________________________________________________________________________________________\n\n');
	writeln ("Number of Splits = ",Split,'\n');
	write('_____________________________________________________________________________________________\n\n');
	writeln ("With ",K, " warehouses of capacity Nmin = ", Nmin, " and Nmax = ", Nmax, '\n');
	var j=1
	while (j<= K)
		{ 
			write ("Warehouse  ",j, "  should store the categories : {");
			var i= 1
				while (i<= J)
				{ 
					if(x[i][j] == 1)
					{write (" ", i, ", ");}
					i++;
				}	
				
		j++;
		writeln("}\n");
		}
		
		write('\n');
		write('_____________________________________________________________________________________________\n\n');
		var after = new Date();
			writeln("solving time ~= ",(after.getTime()-temp)/1000, " s");
			write('_____________________________________________________________________________________________\n\n');
		
}