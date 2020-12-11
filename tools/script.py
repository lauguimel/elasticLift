from __future__ import print_function
import subprocess
from scipy import optimize
import os 
import csv
import shutil
from scipy import optimize

###### global variables #####
# Forces array
forces=[]
# Current directory
curDir = os.path.dirname(os.path.realpath(__file__))+"/"
# Calcultation directory
calcPath=curDir+"/../"
# Results directory
resultsDir=curDir+"results/"
# Cylinder position
cx=0
cy=0
iteration=0

# Sourcing environment variables
def sourcingVariables():
    cmd ='source /home/rheotool/envRheotool'
    subprocess.call([cmd], shell=True, executable='/bin/bash', cwd=curDir)
    subprocess.call('chmod +x '+calcPath+'writeData', shell=True, executable='/bin/bash', cwd=curDir)

# Reading CSV file
def readCSV(file):
    csvRows =[]
    with open(file) as csvfile:
        csvReader = csv.reader(csvfile, delimiter=',')
        for row in csvReader:
            csvRows.append(row)
    return csvRows

# Modifying cx and cy in geo file
def changeCylinderPosition(x,y):

    # Modifying in controlDict file
    xcOldText= 'const scalar xc'
    ycOldText= 'const scalar yc'
    
    xcNewText= '          const scalar xc = '+str(x)+';'
    ycNewText= '          const scalar yc = '+str(y)+';'
    
    # For torque calculation
    cmdXc = 'sed -i "/'+xcOldText+'/c\\'+xcNewText+'" '+curDir+'../system/controlDict'
    cmdYc = 'sed -i "/'+ycOldText+'/c\\'+ycNewText+'" '+curDir+'../system/controlDict'

    subprocess.call([cmdXc], shell=True, executable='/bin/bash', cwd=curDir)
    subprocess.call([cmdYc], shell=True, executable='/bin/bash', cwd=curDir)

    # for BC in U file
    cmdXc2 = 'sed -i "/'+xcOldText+'/c\\'+xcNewText+'" '+curDir+'../0/U'
    cmdYc2 = 'sed -i "/'+ycOldText+'/c\\'+ycNewText+'" '+curDir+'../0/U'

    subprocess.call([cmdXc2], shell=True, executable='/bin/bash', cwd=curDir)
    subprocess.call([cmdYc2], shell=True, executable='/bin/bash', cwd=curDir)

    # Modifying in geo file
    cmdCx = 'sed -i "/cx=/c\\cx='+str(x)+';" '+curDir+'mesh.geo'
    cmdCy = 'sed -i "/cy=/c\\cy='+str(y)+';" '+curDir+'mesh.geo'
    subprocess.call([cmdCx], shell=True, executable='/bin/bash', cwd=curDir)
    subprocess.call([cmdCy], shell=True, executable='/bin/bash', cwd=curDir)

# Deleting mesh
def deleteMesh():
    path=calcPath+"constant/polyMesh"
    shutil.rmtree(path, ignore_errors=True)

# Deleting calculation
def deleteCalc():
    # Deleting folders
    folders=(next(os.walk(calcPath))[1])
    foldersToKeep=["constant", "system","tools", "0", ".git" ]
    for f in folders:
        if f not in foldersToKeep:
            path=calcPath+f
            shutil.rmtree(path, ignore_errors=True)
    # Deleting files
    files=(next(os.walk(calcPath))[2])
    filesTokeep=["writeData",".Xauthority",".gitignore"]
    for f in files:
        if f not in filesTokeep:
            path=calcPath+f
            os.remove(path)

# Saving last calculation step once successfully finished
def savingCalculationFolders(folderName):
    # getting folders
    folders=(next(os.walk(calcPath))[1])
    # removing tools folder
    folders.remove('tools')
    for f in folders:
        shutil.copytree(f, folderName+f)

# Removing all the results (if any)
def deleteResults():
    for root, dirs, files in os.walk(resultsDir):
        for f in files:
            os.unlink(os.path.join(root, f))

# 
def allClean():
    deleteMesh()
    deleteCalc()

def generateMesh():
    f=open(calcPath+"log.mesh","w") 

    meshFileName="mesh"
    cmdMeshGeneration =  "source " +curDir+"meshGeneration.sh "+ meshFileName 
    meshGeneration = subprocess.call([cmdMeshGeneration], shell=True, executable='/bin/bash', cwd=curDir,  stdout=f , stderr=f)

# Function applying BC in 0/U and modifying the centroid position in controlDict
#       BC[0] = Ux: x velocity on the cylinder
#       BC[1] = omega: rotational velocity on the cylinder
def setBC(BC):
    UxTextOld="const scalar Vx"
    OmTextOld="const scalar omega"
    
    UxTextNew="	        const scalar Vx = "+str(BC[0])+";"
    OmTextNew="	        const scalar omega = "+str(BC[1])+";"

    cmdUx = 'sed -i "/'+UxTextOld+'/c\\'+UxTextNew+'" '+curDir+'../0/U'
    cmdOm = 'sed -i "/'+OmTextOld+'/c\\'+OmTextNew+'" '+curDir+'../0/U'

    subprocess.call([cmdUx], shell=True, executable='/bin/bash', cwd=curDir)
    subprocess.call([cmdOm], shell=True, executable='/bin/bash', cwd=curDir)

# Getting forces when calculation is done
# Returns Cd, Cl, Tx, Ty, Tz 
def getForces():
    last_line = subprocess.check_output(["tail", "-1", curDir+"../forces.txt"])

    values = [float(x) for x in last_line.split()[0:]]
    return(values[1:]) 

# Running calcultation
# Arguments: BC: Array of floats 
# returns Cd and Tz
def runCalculation(BC):
    global iteration
    iteration += 1
    print("Vx = "+str(BC[0])+", Omega = "+str(BC[1]), end="")
    f=open(calcPath+"tools/logs/"+str(cx)+'_'+str(cy)+'_'+str(iteration),"w")

    deleteCalc()
    setBC(BC)
    subprocess.call(["rheoFoam"], shell=True, executable='/bin/bash', cwd=calcPath, stdout=f , stderr=f)
    global forces
    forces=getForces()
    
    print("--> Cd = "+str(forces[0])+", "+"Cl = "+str(forces[1])+", "+"Tz = "+str(forces[4]))
    
    # Saving values to log file
    
    cmd="echo "+str(forces[0])+','+str(forces[1])+','+str(forces[4])+','+str(BC[0])+','+str(BC[1])+" >> "+str(cx)+"_"+str(cy)+'.csv'
    subprocess.call(cmd, shell=True, executable='/bin/bash', cwd=resultsDir)

    return([forces[0],forces[4]])    

# Main function
def main():
    #Sourcing environment variables
    sourcingVariables() 

    # Delete previous results if any
    deleteResults()

    positions = readCSV(curDir+'positions.csv')
    subprocess.call('> batch.csv', shell=True, executable='/bin/bash', cwd=resultsDir)

    # Looping over all calculations
    for idx, row in enumerate(positions):

        global cx,cy,iteration
        cx=row[0]
        cy=row[1]
        iteration=0
        
        fileResults = open(resultsDir+cx+"_"+cy+".csv", "w")
        
        # initial guess for boundary conditions
        # get the values from the previous position
        if idx != 0: 
            results=readCSV(curDir+"results/batch.csv")
            BC=results[-1][-2:]
        else :
            BC = [0.0,0.0]

        print("################### Starting new calculation: cx = "+str(cx)+", cy = "+str(cy)+" ###################")
        allClean()
        changeCylinderPosition(cx,cy)
        generateMesh()
        sol = optimize.root(runCalculation, [float(BC[0]),float(BC[1])], method='hybr', tol=1e-3)
    
        cmd="echo "+str(sol.success)+','+sol.message+','+str(forces[0])+','+str(forces[1])+','+str(forces[4])+','+str(sol.x[0])+','+str(sol.x[1])+" >> batch.csv"
        subprocess.call(cmd, shell=True, executable='/bin/bash', cwd=resultsDir)

        # Saving the last timestep folder + constant + system + 0 
        destFolder = resultsDir+cx+'_'+cy+'/'
        print('Saving simulation folders to ' + destFolder)
        savingCalculationFolders(destFolder)


main()
