{**
 * @file plugins/importexport/crossref/templates/articles.tpl
 *
 * Copyright (c) 2013-2014 Simon Fraser University Library
 * Copyright (c) 2003-2014 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Select articles for export.
 *}
{strip}
{assign var="pageTitle" value="plugins.importexport.common.export.selectArticle"}
{assign var="pageCrumbTitle" value="plugins.importexport.common.export.selectArticle"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">{literal}
  function toggleChecked() {
    var elements = document.getElementById('articlesForm').elements;
    for (var i=0; i < elements.length; i++) {
      if (elements[i].name == 'articleId[]') {
        elements[i].checked = !elements[i].checked;
      }
    }
  }
{/literal}</script>

<br/>

<div id="articles">
  <form action="{plugin_url path="process"}" method="post" id="articlesForm">
    <input type="hidden" name="target" value="article" />
    <table width="100%" class="listing">
      <tr>
        <td colspan="6" class="headseparator">&nbsp;</td>
      </tr>
      <tr class="heading" valign="bottom">
        <td width="5%">&nbsp;</td>
        <td width="25%">{translate key="issue.issue"}</td>
        <td width="40%">{translate key="article.title"}</td>
        <td width="25%">{translate key="article.authors"}</td>
        <td width="5%">{translate key="common.action"}</td>
        <td width="5%" align="center">{translate key="common.status"}</td>
      </tr>
      <tr>
        <td colspan="6" class="headseparator">&nbsp;</td>
      </tr>

      {iterate from=articles item=articleData}
        {assign var=article value=$articleData.article}
        {assign var=issue value=$articleData.issue}
        {if $article->getData('ezid::registeredDoi')}
          {capture assign="updateOrRegister"}{translate key="plugins.importexport.ezid.update"}{/capture}
          {capture assign="updateOrRegisterDescription"}{translate key="plugins.importexport.ezid.updateDescription"}{/capture}
        {else}
          {capture assign="updateOrRegister"}{translate key="plugins.importexport.common.register"}{/capture}
          {capture assign="updateOrRegisterDescription"}{translate key="plugins.importexport.common.registerDescription"}{/capture}
        {/if}
        <tr valign="top">
          <td><input type="checkbox" name="articleId[]" value="{$article->getId()}"/></td>
          <td><a href="{url page="issue" op="view" path=$issue->getId()}" class="action">{$issue->getIssueIdentification()|strip_tags}</a></td>
          <td><a href="{url page="article" op="view" path=$article->getId()}" class="action">{$article->getLocalizedTitle()|strip_unsafe_html}</a></td>
          <td>{$article->getAuthorString()|escape}</td>
          <td><nobr>
            {if $hasCredentials}
              <a href="{plugin_url path="process" articleId=$article->getId() params=$testMode target="article" register=true}" title="{$updateOrRegisterDescription}" class="action">{$updateOrRegister}</a>
            {/if}
            <a href="{plugin_url path="process" articleId=$article->getId() params=$testMode target="article" export=true}" title="{translate key="plugins.importexport.common.exportDescription"}" class="action">{translate key="common.export"}</a>
          </nobr></td>
          <td align="center">
            {if $article->getData('ezid::registeredDoi')}
              <a href="http://dx.doi.org/{$article->getData('ezid::registeredDoi')|escape}" target="_blank">doi:{$article->getData('ezid::registeredDoi')|escape}</a>
              {if $article->getData('ezid::registeredDoi') != $article->getStoredPubId('doi')}
                {translate key="plugins.importexport.ezid.doiMismatch" storedDoi=$article->getStoredPubId('doi')}
              {/if}
            {else}
              -
            {/if}
          </td>
        </tr>
        <tr>
          <td colspan="6" class="{if $articles->eof()}end{/if}separator">&nbsp;</td>
        </tr>
      {/iterate}
      {if $articles->wasEmpty()}
        <tr>
          <td colspan="6" class="nodata">{translate key="plugins.importexport.common.export.noArticles"}</td>
        </tr>
        <tr>
          <td colspan="6" class="endseparator">&nbsp;</td>
        </tr>
      {else}
        <tr>
          <td colspan="2" align="left">{page_info iterator=$articles}</td>
          <td colspan="4" align="right">{page_links anchor="articles" name="articles" iterator=$articles}</td>
        </tr>
      {/if}
    </table>
    <p>
      {if !empty($testMode)}<input type="hidden" name="testMode" value="1" />{/if}
      {if $hasCredentials}
        <input type="submit" name="register" value="{translate key="plugins.importexport.common.register"}" title="{translate key="plugins.importexport.common.registerDescription.multi"}" class="button defaultButton"/>
        &nbsp;
      {/if}
      <input type="button" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" />
    </p>
    <p>
      {if !$hasCredentials}
        {capture assign="settingsUrl"}{plugin_url path="settings"}{/capture}
        {translate key="plugins.importexport.common.register.noCredentials" settingsUrl=$settingsUrl}
      {/if}
    </p>
  </form>
</div>

{include file="common/footer.tpl"}
