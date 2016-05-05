WITH CONVOI
     AS (SELECT [CA_D_INSC_REQT], [CA_N_IDEN_REQT], [CA_NM_LIBL_SERV_ASYN], [CA_D_HR_EXEC_PLAN],
                Row_number()
                  OVER( --OVER permet d'ajouter des numéros de lignes sur la partition (équivalent d'un group by)
                    PARTITION BY CASE WHEN[CA_C_MODE_REQT_CONT] = 'AvecConvoi'
                                    THEN [R].[CA_N_IDEN_CONV] -- Numéro applicatif du convoi
                                    ELSE CONVERT(NVARCHAR(50), [R].[CA_N_IDEN_REQT]) -- Dans le cas d'un traitement SansConvoi, on utilise le GUID, qui est unique
                                 END
                    ORDER BY[CA_D_INSC_REQT] ) AS NumeroLigne
         FROM   [dbo].[CA1_REQUETE_ASYNCHRONE] R
         WHERE [CA_D_HR_FIN_REQT] IS NULL --Sélectionner seulement les éléments actifs
         ),
     A_TRAITER
     AS (SELECT TOP 1000 [CA_NM_LIBL_SERV_ASYN], [CONVOI].[CA_D_INSC_REQT]
         FROM [CONVOI]
                --Récupérer le suivi le plus récent
                OUTER APPLY (SELECT TOP 1 [CA_E_REQT]
                             FROM  [dbo].[CA1_SUIVI_REQUETE] SUIVI
                             WHERE [SUIVI].[CA_D_INSC_REQT] = [CONVOI].[CA_D_INSC_REQT]
                                   AND [SUIVI].[CA_N_IDEN_REQT] = [CONVOI].[CA_N_IDEN_REQT]
                             ORDER  BY [CA_D_HR_E_REQT] DESC) SUIVI
         WHERE [CONVOI].[NumeroLigne] = 1 --Prendre uniquement le premier élément de chaque convoi
               AND [CA_D_HR_EXEC_PLAN] < SYSDATETIME() --Prendre ce qui est dû pour être traité
               AND [SUIVI].[CA_E_REQT] IN( 'INSCRIPTION', 'REPRISE' ) --Uniquement ce qui est dans un état "d'attente"
               AND [CA_NM_LIBL_SERV_ASYN] IS NULL --Uniquement ce qui n'a pas été assigné
         ORDER BY [CA_D_INSC_REQT])
--Assigner le serveur qui va traiter les requêtes (pour réservation)
UPDATE [A_TRAITER] SET [CA_NM_LIBL_SERV_ASYN] = 'LOL'
