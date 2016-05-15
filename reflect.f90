PROGRAM REFLECT

	!Down is positive, phi goes from -pi to pi, u from -1 to 1
	INTEGER :: i, n, clock, photons=0, j, k, reflected=0
	REAL :: r, mu, phi, u, v, w, u_new, v_new, w_new, thick=1., tau_m, tau, pi=4*atan(1.), z=0
	REAL :: a, b, c, d, p(40,40)=0, radiance(40), albedo=1.
        INTEGER, DIMENSION(:), ALLOCATABLE :: seed

	!Generate random number vector
	CALL RANDOM_SEED(size = n)
        ALLOCATE(seed(n))
        CALL SYSTEM_CLOCK(COUNT=clock) 
        seed = clock + 37 * (/ (i - 1, i = 1, n) /)
        CALL RANDOM_SEED(PUT = seed) 
        DEALLOCATE(seed)

	!Send many photons through
	do while (photons .lt. 5000000)
		u=-sin(pi/3.)			!Reset intial conditions
		v=0.
		w=cos(pi/3.)
		z=0.
		tau_m=thick/abs(w)
	
		!Check if photon made no collisions; if so, ignore it; otherwise run collision loop
		CALL RANDOM_NUMBER(r)
		tau=-log(r)					!Determine how far packet got along trajectory
		if (tau .lt. tau_m) then
			do	
				!Collision

				z=z+tau*w				!Update packet depth
				CALL RANDOM_NUMBER(r)
				phi=2*pi*(r-.5)				!Randomly generate phi after collision
				do	
					!Randomly generate mu after collision
					CALL RANDOM_NUMBER(r)
					y=3*r/4
					CALL RANDOM_NUMBER(r)
					x=2*r-1
					if (y .le. 3./8.*(1+x*x)) then
						mu=x				
						exit
					endif
				enddo

				!Calculate direction cosines after collision
				a=mu
				b=sin(acos(mu))
				c=cos(phi)
				d=sin(phi)
				if (abs(w) .ge. .99) then		

					u_new=b*c
					v_new=b*d
					w_new=a*w
				else

					u_new=(b*c*w*u-b*d*v)/sqrt(1-w*w) + a*u
					v_new=(b*c*w*v-b*d*u)/sqrt(1-w*w) + a*v
					w_new= -b*c*sqrt(1-w*w) + a*w
				endif
				u=u_new
				v=v_new
				w=w_new

				!Calculate distance to exit along postcollision trajectory
				if (w .ge. 0) then			
					tau_m=(thick - z)/w
					else 
					tau_m= z/abs(w)
				endif

				!Check if photon escaped; if so, bin it
				CALL RANDOM_NUMBER(r)
				tau=-log(r)
				if (tau .ge. tau_m) then
					mu=w
					if (mu .ge. 0) then
						reflected=reflected+1
						photons=photons+1
						exit
					endif
					if (u .ge. 0.) then
						phi_f=atan(v/u)	
					else
						phi_f=atan(v/u)+pi*v/abs(v)
					endif
					j=ceiling(mu*20.)+20
					k=ceiling(phi_f*20./pi)+20
					p(j,k)=p(j,k)+1
					photons=photons+1
					!print *, "Number of photons binned:", photons
					exit
				endif
			enddo
		else
			reflected=reflected+1
			photons=photons+1

		endif
	enddo

	!Send reflected photons back through
	do while (reflected .gt. 0)
		CALL RANDOM_NUMBER(r)				!Lambertian reflectes photons randomly from bottom
		w=-sqrt(r)
		CALL RANDOM_NUMBER(r)
		phi=2*pi*(r-.5)
		u=sin(acos(w))*cos(phi)
		v=sin(acos(w))*sin(phi)
		z=1.
		tau_m=thick/abs(w)
	
		!Check if photon made no collisions; if so, ignore it; otherwise run collision loop
		CALL RANDOM_NUMBER(r)
		tau=-log(r)					!Determine how far packet got along trajectory
		if (tau .gt. tau_m) then
			mu=w
			if (u .ge. 0.) then
				phi_f=atan(v/u)	
			else
				phi_f=atan(v/u)+pi*v/abs(v)
			endif
			j=ceiling(mu*20.)+20
			k=ceiling(phi_f*20./pi)+20
			p(j,k)=p(j,k)+1*albedo
			reflected=reflected-1
		else
			do	
				!Collision

				z=z+tau*w				!Update packet depth
				CALL RANDOM_NUMBER(r)
				phi=2*pi*(r-.5)				!Randomly generate phi after collision
				do	
					!Randomly generate mu after collision
					CALL RANDOM_NUMBER(r)
					y=3*r/4
					CALL RANDOM_NUMBER(r)
					x=2*r-1
					if (y .le. 3./8.*(1+x*x)) then
						mu=x				
						exit
					endif
				enddo

				!Calculate direction cosines after collision
				a=mu
				b=sin(acos(mu))
				c=cos(phi)
				d=sin(phi)
				if (abs(w) .ge. .99) then		

					u_new=b*c
					v_new=b*d
					w_new=a*w
				else

					u_new=(b*c*w*u-b*d*v)/sqrt(1-w*w) + a*u
					v_new=(b*c*w*v-b*d*u)/sqrt(1-w*w) + a*v
					w_new= -b*c*sqrt(1-w*w) + a*w
				endif
				u=u_new
				v=v_new
				w=w_new

				!Calculate distance to exit along postcollision trajectory
				if (w .ge. 0) then			
					tau_m=(thick - z)/w
					else 
					tau_m= z/abs(w)
				endif

				!Check if photon escaped; if so, bin it
				CALL RANDOM_NUMBER(r)
				tau=-log(r)
				if (tau .ge. tau_m) then
					mu=w
					if (mu .ge. 0) then
						exit
					endif
					if (u .ge. 0.) then
						phi_f=atan(v/u)	
					else
						phi_f=atan(v/u)+pi*v/abs(v)
					endif
					j=ceiling(mu*20.)+20
					k=ceiling(phi_f*20./pi)+20
					p(j,k)=p(j,k)+1*albedo
					reflected=reflected-1
					exit
				endif
			enddo
		endif
	enddo


	open(unit=8, file="data.dat")
	do j=1,20
		x=0
		mu=(j-20.5)/20.
		!do k=1,40
			radiance(j)=(p(j,1)+p(j,40))*10.*20./(pi*(photons)*abs(mu))*150/215
			x=x+radiance(j)
		!enddo
		!print *, x
		write(8,*) mu, x
	enddo	
	close(8)

END PROGRAM REFLECT
