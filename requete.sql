WITH CONVOI
     AS (SELECT [CA_NM_LIBL_SERV_ASYN], [CA_D_HR_EXEC_PLAN], [CA_E_REQT], [CA_C_TYPE_REQT_ASYN],
                Row_number()
                  OVER( --OVER permet d'ajouter des numéros de lignes sur la partition (équivalent d'un group by)
                    PARTITION BY CASE WHEN [R].[CA_C_MODE_REQT_CONT] = 'AvecConvoi'
                                    THEN [R].[CA_N_IDEN_CONV] -- Numéro applicatif du convoi
                                    ELSE [R].[CA_N_EVEN_AFFR_RECP] + CONVERT(varchar(3),ABS(CHECKSUM(NEWID())) % {maximumParEvenementAffaire}) -- Dans le cas d'un traitement SansConvoi, crée un convoi éphémère
                                 END
                    ORDER BY[CA_D_INSC_REQT] ) AS NumeroLigne
         FROM [dbo].[CA1_REQUETE_ASYNCHRONE] R
         WHERE [CA_D_HR_FIN_REQT] IS NULL --Sélectionner seulement les éléments actifs
         ),
     A_TRAITER
     AS (SELECT TOP {maximumLecture} [CA_NM_LIBL_SERV_ASYN]
         FROM [CONVOI]
         WHERE [CONVOI].[NumeroLigne] = 1 
               AND [CA_D_HR_EXEC_PLAN] < SYSDATETIME() 
               AND ([CA_E_REQT] IN ( 'INSCRIPTION', 'REPRISE' ) 
               OR ( [CA_E_REQT] = 'FIN_ANORMALE' AND [CA_C_TYPE_REQT_ASYN] = 'Continu'))
               AND [CA_NM_LIBL_SERV_ASYN] IS NULL--Uniquement ce qui n'a pas été assigné
         )
UPDATE [A_TRAITER] SET [CA_NM_LIBL_SERV_ASYN] = '{cleServeur}'
