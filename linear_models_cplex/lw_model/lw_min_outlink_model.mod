/*********************************************
 * OPL 20.1.0.0 Model
 * Author: MatthieuL
 * Creation Date: Jul. 2, 2022 at 3:31:45 p.m.
 *********************************************/

// Measure execution time

float temp;
execute{
var before = new Date();
temp = before.getTime();
}

 //Input parameters 

	int J = ...; 			// Number of categories stored
	int K = ...; 			// Number of warehourses
	int NMax = ...;			// Max categories that can be stored on each warehouse
	int NMin = ...;			// Min categories that can be stored on each warehouse
	range j = 1..J;	 		// Set of product categories
	range k = 1..K;			// Set of warehouses
	float L[j][j] = ...;	// Sum of the weighted links between category for all customer ordres
	
//Decision variables
	
	dvar boolean x[j][k]; 	// If category Cj is allocated to warehouse Wk, x[j][k] = 1 else = 0

//Expression
 
 dexpr float LWout = sum (k in 1..K, g in 1..K, j in 1..J-1,q in j + 1 .. J: k != g ) L[j][q]*x[j][k]*x[q][g];
 dexpr float LWin = sum (k in 1..K, j in 1..J-1,q in j + 1 .. J) L[j][q]*x[j][k]*x[q][k];  
	
//Obj 
	
	minimize LWout;

// Constraints

subject to {

MaxOneAffect: forall(j in 1..J) sum(k in 1..K) x[j][k] == 1;

CapaMaxWarehouse: forall(k in 1..K) sum(j in 1..J) x[j][k ]<= NMax;

CapaMinWarehouse: forall(k in 1..K) sum(j in 1..J) x[j][k ] >= NMin;

}

//Display
	
execute Display {
	write('_____________________________________________________________________________________________\n\n');
	writeln ("Number of outlink = ",LWout, '\n');
	writeln ("Number of inlink = ",LWin, '\n');
	write('_____________________________________________________________________________________________\n\n');
	writeln ("With ",K, " warehouses of capacity Nmin = ", NMin, " and Nmax = ", NMax, '\n');
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