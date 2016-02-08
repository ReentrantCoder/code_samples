import java.lang.Math;
import java.util.Arrays;

public class cholesky {
	public static void main(String[] args){
		int n = 4; //Matrix size
		double a[][] = {
				{.05, .07, .06, .05}, //Starting matrix A
				{.07, .10, .08, .07},
				{.06, .08, .10, .09},
				{.05, .07, .09, .10}
				};
		double b[] = {.23, .32, .33, .31}; //  Ax = b
		double y[] = new double[n]; // Intermediate solution
		double x[] = new double[n]; // Final solution
		double l[][] = new double[n][n]; //Lower triangular matrix L
		double lt[][] = l; //L transpose
		double acc;		//Temporary variable for summations
		
		for ( int k = 0; k < n; k++ ){ //Cholesky Factorization
			acc = 0;
			for (int s = 0; s < k; s++ ) acc += l[k][s]*l[k][s];
			l[k][k] = Math.sqrt(a[k][k] - acc );
			for ( int i = k ; i < n; i++){
				acc = 0;
				for (int s = 0; s < k; s++ ) acc += l[i][s]*l[k][s];
				l[i][k] = (a[i][k] - acc)/l[k][k];				
			}
		}
		
		for ( int i = 0; i < n; i++ ){ //Calculate transpose
			for ( int j = 0; j < n; j++) lt[i][j] = l[j][i];
		}
		
		for ( int i = 0; i < n; i++ ){ //Forward substitute to solve Ly = b
			acc = 0;
			for ( int j = 0; j < i; j++ ) acc += l[i][j]*y[j];
			y[i] = ( b[i] - acc ) / l[i][i];
		}
		
		for ( int i = n - 1; i > 0; i-- ){ //Back substitute to solve Lt*x = y
			acc = 0;
			for ( int j = i + 1; j < n; j++ ) acc += lt[i][j]*x[j];
			x[i] = ( y[i] - acc ) / lt[i][i];
		}
		
		//System.out.println(Arrays.deepToString(l));
		System.out.println(Arrays.toString(x));
		
	}

}