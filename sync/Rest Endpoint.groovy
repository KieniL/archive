import com.atlassian.jira.component.ComponentAccessor
import com.onresolve.scriptrunner.runner.rest.common.CustomEndpointDelegate
import groovy.transform.BaseScript
import groovy.json.JsonSlurper
import groovy.json.JsonOutput
import com.atlassian.jira.issue.MutableIssue
import com.atlassian.jira.event.type.EventDispatchOption
import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.IssueManager
import java.text.SimpleDateFormat
import java.sql.Timestamp



import javax.ws.rs.core.MediaType
import javax.ws.rs.core.MultivaluedMap
import javax.ws.rs.core.Response

@BaseScript CustomEndpointDelegate delegate

class Data {
	def summary
	def key
    def startDate
    def dueDate
    
    Data(summary, key, startDate, dueDate)
    {
        this.summary = summary
        this.key = key
        this.startDate = startDate
        this.dueDate = dueDate
    }
}

//function to create Task in OpenProject
void createTask(String pushPath, MutableIssue issue, CustomField openProjectField, IssueManager issueManager, CustomField startDateField, CustomField endDateField) {
    String responseString = "";
    String outputString = "";
    def dateFormat = new SimpleDateFormat("yyyy-MM-dd")
    def start, end
    if (issue.getCustomFieldValue(startDateField) != null)
    {
        start = dateFormat.format(issue.getCustomFieldValue(startDateField))
    }else
    {
        start = ""
    }
    
    if(issue.getCustomFieldValue(endDateField) != null)
    {
        end = dateFormat.format(issue.getCustomFieldValue(endDateField))
    }else
    {
        end = ""
    }
    def params = "{"+
        "\"subject\" : \""+issue.summary+"\","+
        "\"description\" : \""+issue.description+"\","+
        "\"customField1\" : \""+issue.key+"\","+
        "\"startDate\" : \""+start+"\","+
        "\"dueDate\" : \""+end+"\","+
        "\"_links\": {"+
        "\"type\": {"+
        "\"href\": \"/api/v3/types/1\""+
        "},"+
        "\"project\": {"+
        "\"href\": \"/api/v3/projects/1\"}"+
        "}"+
        "}"
    URL url = new URL(pushPath)
    HttpURLConnection con = (HttpURLConnection)url.openConnection()
    con.setRequestMethod("POST")
    con.setRequestProperty("Content-Type", "application/json")
    con.setRequestProperty("Accept", "application/json")

    String userCredentials = "apikey:46d82f0bbad82acc98828d6c329c6a28a53bdb477f98a8ecb0603b62ba3cbb8b";
    String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userCredentials.getBytes()));
    con.setRequestProperty ("Authorization", basicAuth);
    con.setDoOutput(true)
    try 
    {
        OutputStream os = con.getOutputStream()
        os.write(params.toString().getBytes())
        os.flush()       
    }catch(Exception e)
    {
		log.warn(e.getMessage())
    }
    try
    {
        //Read the response.
        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF8"));

        //Write the message response to a String.
        while ((responseString = br.readLine()) != null) {
            outputString = outputString + responseString;
        }


        def openprojectKey = new JsonSlurper().parseText(outputString)["id"]

        if (openprojectKey)
        {
            issue.setCustomFieldValue(openProjectField, openprojectKey.toString())
            issueManager.updateIssue(ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser(), issue, EventDispatchOption.DO_NOT_DISPATCH, false)
        }
    }catch(Exception e)
    {
        log.warn(e.getMessage())
    }
}

void updateTask (String path, MutableIssue issue, CustomField startDateField, CustomField endDateField)
{
    String responseString = "";
    String outputString = "";
    URL url = new URL(path)
    HttpURLConnection con = (HttpURLConnection)url.openConnection()
    con.setRequestMethod("GET")
    con.setRequestProperty("Content-Type", "application/json")
    con.setRequestProperty("Accept", "application/json")

    String userCredentials = "apikey:46d82f0bbad82acc98828d6c329c6a28a53bdb477f98a8ecb0603b62ba3cbb8b";
    String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userCredentials.getBytes()));
    con.setRequestProperty ("Authorization", basicAuth);
    con.setDoOutput(true)
    try
    {
        //Read the response.
        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF8"));

        //Write the message response to a String.
        while ((responseString = br.readLine()) != null) {
            outputString = outputString + responseString;
        }
        
        def dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        def start, end
        if (issue.getCustomFieldValue(startDateField) != null)
        {
            start = dateFormat.format(issue.getCustomFieldValue(startDateField))
        }else
        {
            start = ""
        }

        if(issue.getCustomFieldValue(endDateField) != null)
        {
            end = dateFormat.format(issue.getCustomFieldValue(endDateField))
        }else
        {
            end = ""
        }

        def lockVersion = new JsonSlurper().parseText(outputString)["lockVersion"]
        def params = "{"+
            "\"subject\" : \""+issue.summary+"\","+
            "\"description\" : \""+issue.description+"\","+
            "\"lockVersion\" : \""+lockVersion+"\","+
            "\"startDate\" : \""+start+"\","+
        	"\"dueDate\" : \""+end+"\","+
            "\"_links\": {"+
            "\"type\": {"+
            "\"href\": \"/api/v3/types/1\""+
            "},"+
            "\"project\": {"+
            "\"href\": \"/api/v3/projects/1\"}"+
            "}"+
            "}"
        
        con = (HttpURLConnection)url.openConnection()
        con.setRequestProperty("X-HTTP-Method-Override", "PATCH")
		con.setRequestMethod("POST")
        con.setRequestProperty("Content-Type", "application/json")
        con.setRequestProperty("Accept", "application/json")

        con.setRequestProperty ("Authorization", basicAuth);
        con.setDoOutput(true)
        try 
        {
            OutputStream os = con.getOutputStream()
            os.write(params.toString().getBytes())
            os.flush()       
        }catch(Exception e)
        {
            log.warn("Stream")
            log.warn(e.getMessage())
        }
        try
    	{
            //Read the response.
           br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF8"));

            //Write the message response to a String.
			outputString = ""
            while ((responseString = br.readLine()) != null) {
                outputString = outputString + responseString;
            }
            log.warn(outputString)

    }catch(Exception e)
    {
        log.warn("Convert")
        log.warn(e.getMessage())
    }
    }catch(Exception e)
    {
        log.warn("Response")
        log.warn(e.getMessage())
    }

}

def basePath = "http://openproject.at/"
def issueManager = ComponentAccessor.getIssueManager()
def customFieldManager = ComponentAccessor.getCustomFieldManager()
def openProjectField = customFieldManager.getCustomFieldObject(10400)
def startDateField = customFieldManager.getCustomFieldObject(10401)
def endDateField = customFieldManager.getCustomFieldObject(10402)

pushData(httpMethod: "GET", groups: ["jira-administrators"]) { MultivaluedMap queryParams ->

    def pushPath = basePath + "api/v3/projects/1/work_packages"
    
    
    if (queryParams.getFirst("project"))
    {
        long projectId = Long.parseLong(queryParams.getFirst("project").toString())

		def issues = issueManager.getIssueObjects(issueManager.getIssueIdsForProject(projectId))

        issues.each
        {
            def issue = (MutableIssue)it
            if (issue.getCustomFieldValue(openProjectField) != null)
            {
                updateTask(basePath + "api/v3/work_packages/"+issue.getCustomFieldValue(openProjectField), issue, startDateField, endDateField)
            }else
            {
                log.warn("Create")
                createTask(pushPath, issue, openProjectField, issueManager, startDateField, endDateField)
            }
        }
    }
    def map = [:]
    map.put("OK", "OK")
   Response.ok(JsonOutput.toJson(map)).build()
}


pullData(httpMethod: "GET", groups: ["jira-administrators"]) { MultivaluedMap queryParams ->

    def openProjectKey = queryParams.getFirst("projectKey")
    
    def pullPath = basePath +"api/v3/projects/1/work_packages?pageSize=1000"
    

    String responseString = "";
    String outputString = "";
    URL url = new URL(pullPath)
    URLConnection connection = url.openConnection()
    HttpURLConnection httpConn = (HttpURLConnection)connection


    //Read the response.
    BufferedReader br = new BufferedReader(new InputStreamReader(httpConn.getInputStream(),"UTF8"));

    //Write the message response to a String.
    while ((responseString = br.readLine()) != null) {
        outputString = outputString + responseString;
    }


    def summary = (ArrayList)new JsonSlurper().parseText(outputString)["_embedded"]["elements"]["subject"]
    def key = (ArrayList)new JsonSlurper().parseText(outputString)["_embedded"]["elements"]["customField1"]
    def startDate = (ArrayList)new JsonSlurper().parseText(outputString)["_embedded"]["elements"]["startDate"]
    def dueDate = (ArrayList)new JsonSlurper().parseText(outputString)["_embedded"]["elements"]["dueDate"]


    def map = [:]
 
    
    for (int i = 0; i < summary.size(); i++)
    {

        def issue = issueManager.getIssueObject(key[i].toString())
        log.warn(issue)
        log.warn("Old Summary " +issue.getSummary())
        issue.setSummary(summary[i].toString())
        log.warn("New Summary " +issue.getSummary())
        log.warn("Summary to change" + summary[i].toString())
        log.warn("STart date" + startDate[i])
        log.warn("End date" + dueDate[i])
        if (startDate[i] != null)
        {
            def date = new SimpleDateFormat("yyyy-MM-dd").parse(startDate[i].toString())
            def timestamp = new Timestamp(date.getTime())
            issue.setCustomFieldValue(startDateField, timestamp)
        }
        if (dueDate[i] != null)
        {
            def date = new SimpleDateFormat("yyyy-MM-dd").parse(dueDate[i].toString())
            def timestamp = new Timestamp(date.getTime())
            issue.setCustomFieldValue(endDateField, timestamp)
        }

        
        issueManager.updateIssue(ComponentAccessor.getJiraAuthenticationContext().getLoggedInUser(), issue, EventDispatchOption.DO_NOT_DISPATCH, false)
    }

 
 map.put('OK', "OK")
 
 Response.ok(JsonOutput.toJson(map)).build()
}


