module.exports = {
  title: 'Rancher on HPE SimpliVity',
  dest: '../MVI1/',
  base: '/Rancher-on-SimpliVity/MVI1/',   
  plugins: ['vuepress-plugin-export'], 
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Blog', link: '/blog/' }
    ],

    repo: 'Rancher-on-SimpliVity',
    // Customising the header label
    // Defaults to "GitHub"/"GitLab"/"Bitbucket" depending on `themeConfig.repo`
    repoLabel: 'Contribute!',

    // Optional options for generating "Edit this page" link

    // if your docs are in a different repo from your main project:

    docsRepo: 'https://github.com/HewlettPackard/Rancher-on-SimpliVity',
    // if your docs are not at the root of the repo:
    docsDir: 'docs-src',
    // if your docs are in a specific branch (defaults to 'master'):
    docsBranch: 'docs-dev',

    // defaults to false, set to true to enable
    editLinks: true,
    // custom text for edit link. Defaults to "Edit this page"
    editLinkText: 'Help us improve this page!',


    sidebar: [
      '/summary',
      {
        title: 'Release Notes',
        collapsable: true,
        children: [
          '/rel-notes/rel-notes',
          //'/rel-notes/new-features',
          //'/rel-notes/fixed-issues',
          '/rel-notes/known-issues'
        ]
      },  
      {
        title: 'Solution overview',
        children: [
          'soln-overview/solution-overview',
          'soln-overview/containers-k8s-devops',
          'soln-overview/rancher-overview',
          'soln-overview/simplivity-overview',
          'soln-overview/solution-configuration',
          'soln-overview/solution-sizing',
          'soln-overview/high-availability',
          'soln-overview/playbooks'
        ]
      },
      {
        title: 'Solution components',
        children: [
          'soln-components/hardware',
          'soln-components/software',
          'soln-components/application-software'
        ]
      },      
      {
        title: 'Preparing the environment ',
        children: [
          'preparing/verify-prereqs',
          'preparing/ansible-fedora'
        ]
      },      
      {
        title: 'Configuring the solution',
        children: [
          'config-core/ansible-config',    
          'config-core/proxy-config',  
          'config-core/edit-hosts', 
          'config-core/vmware-config',
          'config-core/simplivity-config',          
          'config-core/networking-config',              
          'config-core/rancher-config',
          'config-core/rancher-user-config',
          'config-core/lbs-config.md',
          'config-core/csi-storage-config',
          'config-core/group-vars',
          'config-core/edit-vault',
          'config-core/vars-sample',
          'config-core/vault-sample',
          'config-core/hosts-sample'
        ]
      },
      {
        title: 'Running the playbooks',
        children: [
          'playbooks/playbooks-intro',
          'playbooks/prerequisites',
          'playbooks/pre-deployment-validation',
          'playbooks/download-kits',
          'playbooks/initial-deployment',
          'playbooks/redeploy'
        ]
      },
      {
        title: 'Post deployment tasks',
        collapsable: true,
        children: [
          '/post-deploy/post-deploy-intro',
          '/post-deploy/first-login',
          '/post-deploy/auth-active-directory',
          '/post-deploy/csi-storage-verification'
        ]
      },
      {
        title: 'Appendices',
        collapsable: true,
        children: [
          '/appendices/appendixa'
        ]
      }      
    ]
  }
}

      
