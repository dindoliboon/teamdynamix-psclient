<#
    Generates the type definition for the TeamDynamix API.

    Export-TdWebApiTypes.ps1 | Out-File -FilePath 'V:\tdtypes.txt'
#>

#Requires -Version 3

Set-StrictMode -Version 3

$Script:DebugPreference       = 'SilentlyContinue'
$Script:VerbosePreference     = 'SilentlyContinue'

$apiTypeUrls = @'
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Accounts.Account
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Accounts.AccountSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Apps.UserApplication
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.Asset
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.AssetSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.AssetStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.ContactInformation
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.ProductModel
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.ProductType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.Vendor
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Assets.VendorSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Attachments.Attachment
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Attachments.AttachmentType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Auth.AdminTokenParameters
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Auth.LoginParameters
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Briefcase.File
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Briefcase.Folder
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.BulkOperations.BulkImport`1
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.BulkOperations.FieldMapping
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.BulkOperations.ImportSettings
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.BulkOperations.ItemResult
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.BulkOperations.ItemResultType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.BackingItemType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItem
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItemRelationship
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItemSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItemSource
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItemSourceType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationItemType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.ConfigurationRelationshipType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.MaintenanceSchedule
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Cmdb.MaintenanceScheduleSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.Activity
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.ActivityPriority
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.ActivityStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.ActivityType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.EmailActivity
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Crm.EmailAddress
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.CustomAttributes.CustomAttribute
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.CustomAttributes.CustomAttributeChoice
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.FeedEntry
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.FeedItemType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.ItemUpdate
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.ItemUpdateLike
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.ItemUpdateReply
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.Participant
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.TicketFeedEntry
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Feed.UpdateType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Forms.Form
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.Issue
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.IssueRiskCreateOptions
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.IssueSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.IssueStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.IssueUpdate
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.Risk
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.RiskSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Issues.RiskUpdate
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.JsonPatchOperation
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.KnowledgeBase.Article
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.KnowledgeBase.ArticleCategory
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.KnowledgeBase.ArticleSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.KnowledgeBase.ArticleStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Locations.Location
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Locations.LocationRoom
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Locations.LocationSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.ApplicationIdentifier
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.Plan
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.PlanEdit
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.PlanSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.RelationshipType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.Task
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.TaskChanges
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.TaskRelationship
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.TaskResource
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Plans.TaskUpdate
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.PlanUpdates
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.PriorityFactors.Impact
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.PriorityFactors.Priority
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.PriorityFactors.Urgency
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.ProjectRequests.ProjectRequest
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Projects.CustomColumn
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Projects.HealthChoice
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Projects.Project
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Projects.ProjectSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Projects.Resource
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.AggregateFunction
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.ChartSetting
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.ColumnDataType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.ComponentFunction
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.DisplayColumn
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.OrderByColumn
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.Report
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.ReportInfo
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Reporting.ReportSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.ResourceAllocationEditMode
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.ResourceItem
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.FunctionalRole
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.FunctionalRoleSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.LicenseTypes
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.Permission
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.SecurityRole
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.SecurityRoleSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Roles.UserFunctionalRole
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Schedules.ResourcePool
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Schedules.ResourcePoolSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.ServiceCatalog.RequestComponent
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.ServiceCatalog.Service
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Statuses.StatusClass
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.ConflictType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.Ticket
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketClass
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketCreateOptions
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketSource
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketTask
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketTaskType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.TicketType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Tickets.UnmetConstraintSearchType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.BulkOperationResults
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.IndexAndIDPair
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeApiError
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeApiErrorCode
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeEntry
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeEntryComponent
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeReport
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeStatus
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeType
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Time.TimeTypeLimit
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.EligibleAssignment
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.Group
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.GroupMember
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.GroupSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.NewUser
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.User
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserAccountsBulkManagementParameters
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserApplicationsBulkManagementParameters
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserGender
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserGroup
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserGroupsBulkManagementParameters
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserListing
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserSearch
https://app.teamdynamix.com/TDWebApi/Home/type/TeamDynamix.Api.Users.UserType
'@ -split [Environment]::NewLine

Write-Debug -Message 'Output required references'
@'
Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;

'@

$apiTypeUrls | ForEach-Object {
    $outputDeclaration       = $false
    $isClass                 = $false
    $fullTypeName            = $_ -replace 'https://app.teamdynamix.com/TDWebApi/Home/type/', ''
    $typeNameTokens          = $fullTypeName -split '\.'
    $shortObjectName         = $typeNameTokens[$typeNameTokens.Length - 1]
    $shortObjectNameWithType = $shortObjectName
    if ($shortObjectName -like "*`1")
    {
        $shortObjectName         = $shortObjectName -replace '`1', ''
        $shortObjectNameWithType = $shortObjectName + '<T>'
    }

    $typeNameTokens[$typeNameTokens.Length - 1] = $null
    $namespace                                = ($typeNameTokens | Where-Object { $null -notlike $_ }) -join '.'

    Write-Debug -Message "Process URL $_"
    $request    = Invoke-WebRequest -Method 'Get' -Uri $_

    $classTitle = ($request.ParsedHtml.getElementsByTagName('p') | Where-Object { $_.getAttributeNode('class').Value -eq 'lead' }).innerText
    $enumOutput = @()

    Write-Debug -Message "Output namespace $namespace"
    "// Autogenerated $(Get-Date): $_"
    "namespace $namespace"
    '{'

    Write-Debug -Message "Parse first table"
    . "$PSScriptRoot\Get-WebRequestTable.ps1" -WebRequest $request -TableNumber 0 | ForEach-Object {
        if ($_.PSObject.Properties['Type']) {
            if ($outputDeclaration -eq $false)
            {
                Write-Debug -Message "Output class $shortObjectNameWithType"

                "    /// <summary>$($classTitle.Trim())</summary>"
                "    public class $shortObjectNameWithType"
                '    {'

                $outputDeclaration = $true
                $isClass = $true
            }

            $nullable = ''
            $type     = $_.Type

            Write-Debug -Message "Check for any special object types [$type]"

            if ($type -like "*IEnumerable(Of *")
            {
                $type = $type -replace '\(Of ', '<'
                $type = $type -replace '\)', '>'
            }

            if ($type -like "*List(Of *")
            {
                $type = $type -replace '\(Of ', '<'
                $type = $type -replace '\)', '>'
            }

            if ($type -like "*Nullable(Of *")
            {
                $type     = $type -replace 'Nullable\(Of ', ''
                $type     = $type -replace '\)', ''
                $nullable = '?'
            }

            Write-Debug -Message "Output property $($_.Name)"
            "        /// <summary>$($_.PSObject.Properties['Summary'].value)</summary>"
            "        public $($type)$($nullable) $($_.Name) { get; set; }"
        }
        elseif ($_.PSObject.Properties['Value']) {
            if ($outputDeclaration -eq $false)
            {
                Write-Debug -Message "Output enum $shortObjectName"

                "    /// <summary>$($classTitle.Trim())</summary>"
                "    public enum $shortObjectName"
                '    {'

                $outputDeclaration = $true
            }

            $enumOutput += ("        /// <summary>$($_.PSObject.Properties['Summary'].value)</summary>" + [Environment]::NewLine + "        $($_.Name) = $($_.Value)")
        }
    }

    Write-Debug -Message 'Output enum values'
    $enumOutput -join (',' + [Environment]::NewLine)

    if ($isClass -eq $true) {
        Write-Debug -Message "Output class constructor $shortObjectName"
        "        public $shortObjectName() { }"
    }

    Write-Debug -Message 'Output closing class/enum'
    '    }'
    '}'
    ''
}

Write-Debug -Message 'Output type definition'
"'@"
