with open("Muestras.txt", "r") as archivo:
        contenido = archivo.readlines()

        # [4.95 6.05 11.3 12.03]
        cordsx1 = [4950, 6050]
        cordsy1 = [11300, 12030]

        # {2.24, -11.72, 5.14 , -9.72}
        cordsx2 = [2240, 5140]
        cordsy2 = [-11720, -9720]
        cont = 0
        impactos1 = 0
        impactos2 = 0
        for i in contenido:

            cont += 1

            a = i.split()

            a[0] = float(a[0])
            a[1] = float(a[1])
            a[2] = float(a[2])

            if (a[1] >= cordsx1[0] and a[1] <= cordsx1[1]):
                if (a[2] >= cordsy1[0] and a[2] <= cordsy1[1]):
                    impactos1 += 1
            if (a[1] >= cordsx2[0] and a[1] <= cordsx2[1]):
                if (a[2] >= cordsy2[0] and a[2] <= cordsy2[1]):
                    impactos2 += 1

        print(cont, impactos1, impactos2)
