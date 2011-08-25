<%@page import="com.vionto.vithesaurus.*" %>

<tr class='prop'>
    <td valign='top' class='name'>
        <h2 class="noTopMargin">${title}</h2>
    </td>
    <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

    <g:set var="nymCount" value="${0}"/>
    
    <ul style="margin-top:0px">
    
        <g:each var='link' in='${synsetLinks}'>
           <g:if test="${link.linkType.toString() == linkTypeName}">
           
                <li class="checkboxList">
                    <input type="hidden" id="delete_${linkTypeName}_${link.id}" name="delete_${linkTypeName}_${link.id}" value=""/>
                    <div id="${linkTypeName}_${link.id}">
        
                        <g:if test="${session.user}">
                          <a href="#" onclick="deleteItem('${linkTypeName}', '${link.id}');return false;"><img 
                            align="top" src="${resource(dir:'images',file:'delete2.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete.link')}"/></a>
                        </g:if>
                        <g:else>
                          <img align="top" src="${resource(dir:'images',file:'delete2_inactive.png')}" alt="delete icon"/>
                        </g:else>
        
                        <g:link controller='synset' action='edit'
                            id='${link.targetSynset.id}'>${link.targetSynset.toShortStringWithShortLevel(3, true).encodeAsHTML()}</g:link>
                            
                    </div>
                </li>
    
                <%
                displayedSynsets.add(link.targetSynset.id)
                nymCount++
                %>
           </g:if>
        </g:each>
        
        <g:if test="${nymCount == 0 && (linkTypeName == 'Unterbegriff' || !session.user)}">
             <li class="checkboxList"><span class="noMatches"><g:message code="edit.not.set"/></span></li>
        </g:if>        

        <g:if test="${session.user && showAddLink}">
        <li class="checkboxList">
            <div id="addSynsetLink-${linkTypeName}" ${nymCount > 0 ? 'style="margin-top:10px"' : ''}>
                <a href="#" onclick="javascript:showNewSynsetLink('${linkTypeName}');return false;"><img align="top" src="${createLinkTo(dir:'images',file:'plus.png')}" alt="Plus"/>&nbsp;<g:message code="edit.add.link" args="${[linkTypeName]}"/></a>
                <g:if test="${linkTypeName == 'Assoziation'}">
                     <a href="#" onclick="javascript:toggleId('associationHelp');return false;">[?]</a>
                </g:if>        
            </div>
            <g:if test="${linkTypeName == 'Assoziation'}">
                <div id="associationHelp" style="display: none">
                    <g:render template="/synset/associationHelp" />
                </div>
            </g:if>        
         <div id="addSynset-${linkTypeName}" style="display:none;margin-top:5px">
            <g:textField name="q${linkTypeName}" value="" onkeypress="return doSearchOnReturn(event, '${linkTypeName}');"/>
            <input type="hidden" name="linkType${linkTypeName}.id" value="${LinkType.findByLinkName(linkTypeName).id}">
            
    		<%-- we have to use this instead of g:remoteLink to inject the value of the search form, see below:  --%>
    		<%-- NOTE: keep in sync with doSearchOnReturn() javascript:--%>
            <a href="${createLinkTo(dir:'synset/ajaxSearch')}" 
            	onclick="new Ajax.Updater('synsetLink${linkTypeName}','${createLinkTo(dir:'synset/ajaxSearch')}',{asynchronous:true,evalScripts:true,onLoaded:function(e){loadedSearch()},onLoading:function(e){loadSearch()},parameters:'q='+document.editForm.q${linkTypeName}.value + '&linkTypeName=${linkTypeName}'});return false;"
            	><g:message code="edit.link.lookup"/></a>
                  
            <!-- see http://jira.codehaus.org/browse/GRAILS-3205 for why we cannot use this:
            <g:submitToRemote value="${message(code:'edit.link.lookup')}" action="ajaxSearch"
                  update="synsetLink" onLoading="loadSearch()" onLoaded="loadedSearch()" method="get" />
            -->
    
            <span id="addSynsetProgress" style="visibility:hidden;position:absolute">
                <img src="${createLinkTo(dir:'images',file:'spinner.gif')}" alt="Spinner image"
                   title="Searching..."/>
            </span>
            <div id="synsetLink${linkTypeName}">
            </div>
         </div>
         </li>
        </g:if>
    
    </ul>
    
    </td>
</tr>
<tr><td></td></tr>
