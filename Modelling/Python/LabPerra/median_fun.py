
def median(files):

  ite=len(files)
  out=[]
  if len(files)%2 ==0:

		  median=[]
		  median=files

		  median=sorted(median)

		  median.reverse()
		  ee=int(float(ite)/2.)

		  m_cinq=ee-1-int((ee-1)*0.5)
		  max_cinq=ee +int((ee-1)*0.5)
		  m_novc=ee-1-int((ee-1)*0.95)
		  max_novc=ee +int((ee-1)*0.95)

		  out.append([(median[ee]+median[ee-1])/2.,median[m_cinq],median[max_cinq],median[m_novc],median[max_novc]])

  else:

		  median=[]
		  median=files

		  median=sorted(median)

		  median.reverse()
		  ee=int(float(ite)/2.+0.5)
		  m_cinq=ee-1-int((ee-1)*0.5)
		  max_cinq=ee-1+int((ee-1)*0.5)
		  m_novc=ee-1-int((ee-1)*0.95)
		  max_novc=ee-1+int((ee-1)*0.95)
		  
		  out.append([median[ee-1],median[m_cinq],median[max_cinq],median[m_novc],median[max_novc]])

  return out
