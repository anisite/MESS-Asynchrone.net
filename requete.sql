WITH CONVOI
     AS (SELECT [CA_NM_LIBL_SERV_ASYN], [CA_D_HR_EXEC_PLAN], [CA_E_REQT], [CA_C_TYPE_REQT_ASYN],
                Row_number()
                  OVER(
                    PARTITION BY CASE WHEN[CA_C_MODE_REQT_CONT] = 'AvecConvoi'
                                    THEN [R].[CA_N_IDEN_CONV] -- Numéro applicatif du convoi
                                    ELSE CONVERT(NVARCHAR(50), [R].[CA_N_IDEN_REQT])
                                 END
                    ORDER BY[CA_D_INSC_REQT] ) AS NumeroLigne
         FROM   [dbo].[CA1_REQUETE_ASYNCHRONE] R
         WHERE [CA_D_HR_FIN_REQT] IS NULL 
         ),
     A_TRAITER
     AS (SELECT TOP {maximumLecture} [CA_NM_LIBL_SERV_ASYN]
         FROM [CONVOI]
         WHERE [CONVOI].[NumeroLigne] = 1 
               AND [CA_D_HR_EXEC_PLAN] < SYSDATETIME() 
               AND ([CA_E_REQT] IN ( 'INSCRIPTION', 'REPRISE' ) 
               OR ( [CA_E_REQT] = 'FIN_ANORMALE' AND [CA_C_TYPE_REQT_ASYN] = 'Continu'))
               AND [CA_NM_LIBL_SERV_ASYN] IS NULL--Uniquement ce qui n'a pas été assigné
         ORDER BY [CA_D_HR_EXEC_PLAN] ASC)
UPDATE [A_TRAITER] SET [CA_NM_LIBL_SERV_ASYN] = '{cleServeur}'
