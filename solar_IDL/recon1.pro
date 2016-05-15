;--------------------------------------------------------------
;+
; NAME:
;	RECON1
; PURPOSE:
;	Reconstructs emnew data using svdc
; CATEGORY:
;	Data combination
; CALLING SEQUENCE:
;	recon1
; INPUTS: 
;	None but must have proper data files in working directory
; KEYWORD PARAMETERS:
;	emded = temporal embedding dimension (must be odd & 3-5 is good)
;	scale = divider of lower & upper bounds of bandpass in days
; OUTPUTS: 
;	None but creates interpolated emission index (eminterp) and its abcissa (xyrf)
; COMMON BLOCKS: cak
; NOTES: 
;	Refer to Dudok de Wit's 'A method for filling gaps in solar irradiance and in
;	solar proxy data' for more info. Comments will reference sections of that paper.
; MODIFICATION HISTORY:
;	Created --- S. Keil
;	Modified --- May, 2012 --- T. Behm
;-
;--------------------------------------------------------------
 
pro recon1, embed=embed, scale=scale
common cak, emnewinterp, xyrf, pwsave, daypeak, freqsave, del

	rad_file='/home/tbehm/Desktop/REUresearch/radio.d'
	nrad=4
	spot_file='/home/tbehm/Desktop/REUresearch/ssn.d'
	nspot=4
	cak_file='/home/tbehm/Desktop/REUresearch/cak.d'
	ncak=10
	mag_file='/home/tbehm/Desktop/REUresearch/mg.d'
	nmag=4

;Build data array containing all days and their values at that day or Nan if no observation
;To disable a proxy, comment it out and reduce later num1's
	;Add sunspot data
	data=read_file(spot_file, nspot,/hdr)
	
	;Add radio data
	c=read_file(rad_file,nrad,/hdr)
	data=nancat(data,c, /mdy1, /mdy2)

	;Add MgII data
	c=read_file(mag_file,nmag,/hdr)
	data=nancat(data,c, /mdy2, num1=2)

	;Add calcium k emission index data
	c=read_file(cak_file,ncak,/hdr)
	emdex=c[3,*]
	xday0=daynum(c, xyr=xyr0)
	data=nancat(data,c, /mdy2, num1=3)

	sz1=(size(data))[1]-1		;number of proxies and thus number of modes
	sz2=(size(data))[2]		;number of days

	;Remove average and stdev
	dataavg=fltarr(sz1)
	datastdev=fltarr(sz1)
	for i=1,sz1 do begin
		dataavg[i-1]=mean(data[i,*], /nan)
		datastdev[i-1]=stddev(data[i,*], /nan)
		data[i,*]=data[i,*]-mean(data[i,*], /nan)
		data[i,*]=data[i,*]/stddev(data[i,*], /nan)	
	endfor
	
	;step 1 interpolate missing data: Section 2.1
	missindex=where(transpose(data) ne transpose(data))	;must transpose b/c 2d is read as 1d via row then column
	obsv=fltarr(sz1)
	for i=1,sz1 do begin
		if data[i,0] ne data[i,0] then data[i,0]=mean(data[i,*], /nan)
		if data[i,n_elements(data[i,*])-1] ne data[i,n_elements(data[i,*])-1] then data[i,n_elements(data[i,*])-1]=mean(data[i,*], /nan)
		loc=where(data[i,*] eq data[i,*], count)
		obsv[i-1]=count
		data[i,*]= interpol(data[i,loc], data[0,loc], data[0,*])	;linear interpolation
	endfor
	
	;weight by # of observed days
	weight=obsv/max(obsv)
	weight=weight*weight
	for i=1,sz1 do begin
		data[i,*]=data[i,*]*weight[i-1]
	endfor

	;Remove average again & keep track so that we can add it later
	arravg=fltarr(sz1)
	for i=1,sz1 do begin
		arravg[i-1]=mean(data[i,*])
		data[i,*]=data[i,*]-mean(data[i,*])	
	endfor

caldat, data[0,*], month, day, year
date=[month, day, year] 
xday=daynum(date, xyr=xyrf)

;find the values of the interpolated missing days
	arr=data[1:sz1,*]
	missindex=missindex-sz2 	; offset b/c of lost column
	arr0=arr

;apply embedding dimension for smoothing in time: Section 2.4
if keyword_set(embed) then begin
	if embed mod 2 ne 1 then begin
		print, 'embedding dimension must be odd integer'
		read, 'input new embed', embed
	endif
	embed=embed-1
	for n=1, embed do begin
		arr=arr*shift(arr,-n)
	endfor
	arr=arr[*,embed/2:sz2-1-embed/2]
endif

for k=0, sz1-4 do begin

	for j=0,100 do begin
;decompose data into different time scales: Section 2.3
		if keyword_set(scale) then begin
			freq=findgen(sz2)/float(sz2)
			mask=freq lt 1./scale
			arrlp=arr
			for i=0, sz1-1 do begin
				arrlp[i,*]=float(fft(fft(arr[i,*],-1)*mask,1))
				;arrlp[i,*]=smooth(arr[i,*], scale)
				;renorm=total(arr[i,*])
				arr[i,*]=arr[i,*]-arrlp[i,*]
				;arr[i,*]=arr[i,*]/total(arr[i,*])*renorm
				;norm=fltarr(4)
				;normlp=norm
				;norm[i]=stddev(arr[i,*])
				;normlp[i]=stddev(arrlp[i,*])
				;arr[i,*]=arr[i,*]/norm[i]
				;arrlp[i,*]=arrlp[i,*]/normlp[i]
			endfor
		endif 
;perform the imputation: Section 2.1
		svdc,arr,w,u,v,/double	;step 2 calculate svdc
		sv=identity(sz1)
		w=[w[0:k],replicate(0,sz1-k)] ;only considers first k weights
   		sv=sv*rebin(w[0:sz1-1],sz1,sz1)	; forms weight array
		v1=transpose(v)
		arrhat=u##sv##v1	;step 3 find truncated arr
		if keyword_set(scale) then begin
			svdc,arrlp,w,u,v,/double	;step 2 calculate svdc
			sv=identity(sz1)
			w=[w[0:k],replicate(0,sz1-k)] ;only considers first k weights
   			sv=sv*rebin(w[0:sz1-1],sz1,sz1)	; forms weight array
			v1=transpose(v)
			arrhatlp=u##sv##v1	;step 3 find truncated arr
			;arrhat=arrhat*rebin(norm,4,sz2)+arrhatlp*rebin(normlp, 4, sz2)
			arrhat=arrhat+arrhatlp
		endif
		arr=transpose(arr)
		arr[missindex]=(transpose(arrhat))[missindex]	;step 4 substitute for missing data
		arr=transpose(arr)
;preprocessing because svdc is scale-dependent: Section 2.2
		for a=0, sz1-1 do begin
			arravg[a]=arravg[a]+mean(arr[a,*])
			arr[a,*]=arr[a,*]-mean(arr[a,*])
		endfor
	endfor ;iterate until converged
print, 'lather, rinse, repeat'
endfor ;step 5 iterate through all the modes

;Undo normalization process
for i=0,sz1-1 do begin
	arr[i,*]=arr[i,*]+arravg[i]
	arr[i,*]=arr[i,*]/weight[i]
	arr[i,*]=arr[i,*]*datastdev[i]
	arr[i,*]=arr[i,*]+dataavg[i]
endfor

!p.multi=[0,1,2]
plot, xyrf, arr[sz1-1,*], /ynoz, title='emdex with svdc imputation'
plot, xyr0, emdex, /ynoz, title='emdex w/o svdc imputation'
!p.multi=0

emnewinterp=reform(arr[sz1-1,*],n_elements(arr[sz1-1,*]))
stop
end

