trigger CdpChangeVisibilityContentDocumentLinkTrigger on ContentDocumentLink(before insert, after insert)
{
    if (Trigger.isInsert) {
        List <Object_Api_Name> productsInvestments = new List <Object_Api_Name> ();
        productsInvestments = [
            SELECT Id
            FROM Object_Api_Name
            WHERE Id =:Trigger.New[0].LinkedEntityId
        ];

        if (Trigger.isBefore) {
            if (productsInvestments.size() > 0) {
                Trigger.New[0].Visibility = 'AllUsers';
            }
        }

        if (Trigger.isAfter) {
            ContentDistribution contentDistribution = new ContentDistribution();

            if (productsInvestments.size() > 0) {
                ContentVersion contentVersion = [
                    SELECT Id, Title
                    FROM ContentVersion
                    WHERE ContentDocumentId =:Trigger.New[0].ContentDocumentId
                ];

                contentDistribution.Name = contentVersion.Title;
                contentDistribution.RelatedRecordId = Trigger.New[0].LinkedEntityId;
                contentDistribution.ContentVersionId = contentVersion.Id;
                contentDistribution.PreferencesAllowViewInBrowser = true;
                contentDistribution.PreferencesLinkLatestVersion = true;
                contentDistribution.PreferencesPasswordRequired = false;
                contentDistribution.PreferencesAllowOriginalDownload = true;
                contentDistribution.PreferencesNotifyOnVisit = false;
                contentDistribution.PreferencesNotifyRndtnComplete = false;

                insert contentDistribution;
            }
        }
    }
}
