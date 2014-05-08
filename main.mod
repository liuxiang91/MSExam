set OPER;
set PROD;
set AGE={"lamb", "adult"};
set SEX={"male", "female"};
param cost {OPER} >= 0;
param price {PROD} >=0;
param u {PROD} >=0;
param x_0_a_m>=0;
param x_0_a_f>=0;
param w_lamb>=0;
param w_pelt>=0;
param h>=0;
param g;
param d_milk;
param T=2;
# --------------------------------------------------------
var x{s in SEX, a in AGE, t in 0..T}>=0;
var y_slau{s in SEX, a in AGE, t in 1..T}>=0;
var y{o in OPER, t in 0..T}>=0;
var w{o in PROD, t in 0..T}>=0;

# --------------------------------------------------------
maximize P: sum{t in 1..T} (g^t * ( -sum{s in SEX, a in AGE} x[s,a,t]*h
									-sum{s in SEX, a in AGE} y_slau[s,a,t]*cost["slaughter"]
									-sum{o in {"breed", "buy", "shear", "pelt", "milk"}} cost[o]*y[o,t]
									+sum{p in {"mutton","milk","wool","milk_over"}} price[p]*w[p,t] )) ;
# --------------------------------------------------------
subject to flow_adult {s in SEX, t in 1..T}:
	x[s,"adult",t]=x[s,"adult",t-1]+x[s,"lamb",t-1]-y_slau[s,"adult",t];

subject to flow_lamb_male {t in 1..T}:
	x["male","lamb",t]=y["breed",t-1]-y_slau["male","lamb",t];

subject to flow_lamb_female {t in 1..T}:
	x["female","lamb",t]=y["breed",t-1]-y_slau["female","lamb",t]+y["buy",t];

subject to slau_oper {s in SEX, a in AGE, t in 1..T}:
	y_slau[s,a,t]<=x[s,a,t];

subject to breed_oper {t in 1..T}:
	y["breed",t]<=x["female","adult",t];

subject to shear_oper {t in 1..T}:
	y["shear",t]<=sum{s in SEX} x[s, "adult",t];

subject to pelt_oper {t in 1..T}:
	y["pelt",t]<=sum{s in SEX} y_slau[s,"adult",t];

subject to milk_oper {t in 1..T}:
	y["milk",t]<=y["breed",t];

subject to mutton_prod {t in 1..T}:
	w["mutton",t]<=u["mutton"]* sum{s in SEX} y_slau[s,"adult",t];

subject to lamb_prod {t in 1..T}:
	w["lamb",t]<=u["lamb"]* sum{s in SEX} y_slau[s,"lamb",t];

subject to milk_prod_demand {t in 1..T}:
	w["milk",t]=d_milk;

subject to milk_prod_over {t in 1..T}:
	w["milk_over",t]+w["milk",t]<=u["milk"]*y["milk",t];

subject to pelt_prod {t in 1..T}:
	w["pelt",t]<=u["pelt"]*y["pelt",t];	

subject to wool_prod {t in 1..T}:
	w["wool",t]<=u["wool"]*y["shear",t];

subject to x_0_lamb {s in SEX}:
	x[s,"lamb",0]=0;

subject to x_0_adult_male:
	x["male","adult",0]=x_0_a_m;

subject to x_0_adult_female:
	x["female","adult",0]=x_0_a_f;

subject to pelt_prod_opt {t in 1..T}:
	w["pelt",t]=w_pelt;

subject to lamb_prod_opt {t in 1..T}:
	w["lamb",t]=w_lamb;

subject to population {t in 1..T}:
	sum{s in SEX, a in AGE} x[s,a,t] <=300;

subject to breed_0:
	y["breed",0]=0;







