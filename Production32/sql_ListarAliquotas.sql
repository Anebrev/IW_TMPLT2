Select                                           
  PPSID, PPSEMP, PPSPRD, PPSVIGINI, PPSVIGFIM,   
  concat(trim(PPSPRD), PPSVIGINI, PPSVIGFIM) as KEY_LINE,   
  PPSICM ALIQ, PPSTP TP, PPSPRECO PRC,           
  PPSICM||trim(PPSTP) ID_COL,                    
  VIGINIANT, VIGFIMANT, PRECOANT, QTALT, CONFRMD 
From                                             
  LPDDBICE.PPSCONSOL                             
Where                                            
  PPSID=2 and PPSICM > 0   
                                       
  and PPSPRD in('JFT','JGQ')

